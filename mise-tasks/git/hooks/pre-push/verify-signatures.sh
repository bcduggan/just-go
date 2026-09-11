#!/usr/bin/sh
#MISE description="Verify git commit and tag signatures before push."
#USAGE arg "<remote>" help="Name of the remote to which the push is being done"
#USAGE arg "<url>" help="URL to which the push is being done"

# Called by "git push" after it has checked the remote status, but before
# anything has been pushed. If this script exits with a non-zero status nothing
# will be pushed.
#
# This hook is called with the following parameters (unused in this script):
#
# $1 -- Name of the remote to which the push is being done
# $2 -- URL to which the push is being done
#
# If pushing without using a named remote those arguments will be equal.
#
# Information about the commits which are being pushed is supplied as lines to
# the standard input in the form:
#
#   <local ref> <local oid> <remote ref> <remote oid>
#
# git invokes the pre-push hook script for each reference it intends to push to
# the remote. For example, git will call the pre-push hook script twice after
# this command, once for feat/new-feature and again for v1.0.0:
#
# ```console
# $ git push --atomic --upstream origin feat/new-feature v1.0.0
# ```
#
# If feat/new-feature and v1.0.0 are a branch and tag, respectively, git will
# pass each of them as $local_ref (in this script) on stdin in two separate
# invocations.
#
# This script verifies signatures on tags and all commits reachable from the
# passed reference that don't exist on the remote before pushing. It fails if
# it can't verify any of them.
#
# This means that this hook script prevents pushing lightweight tags because
# they don't support PGP signatures.

set -euf

zero=$(git hash-object --stdin </dev/null | tr '[0-9a-f]' '0')

while read local_ref local_oid remote_ref remote_oid
do
	if test "$local_oid" = "$zero"
	then
		# Handle delete
		:
	else
		if test "$remote_oid" = "$zero"
		then
			# New branch or tag, examine all commits
			range="$local_oid"
		else
			# Update to existing branch or tag, examine new commits
			range="$remote_oid..$local_oid"
		fi

		# Check for unsigned or signed-but-unverified tags
		#
		# $local_ref is in refs format, so branches will begin with refs/heads and
		# tags will begin with refs/tags.
		if [ "$(echo "$local_ref" | cut -f2 -d/)" = "tags" ]
		then
			# A refs/tags reference is always a tag, but is either an annotated or
			# lightweight tag. 'cat-file -t' outputs the type of git object. Annotated
			# tags are of type "tag" and lightweight tags are of type "commit". Only
			# annotated tags support signtatures.
			if [ "$(git cat-file -t "$local_ref")" = "tag" ]
			then
				if ! git verify-tag "$local_ref" 2>/dev/null
				then
					echo >&2 "Found unsigned or signed-but-unverified tag $local_ref, not pushing"
					exit 1
				fi
			else
				echo "Found lightweight tag $local_ref, not pushing"
				exit 1
			fi
		fi

		# Check for unsigned or signed-but-unverified commits
		commits=$(git rev-list $range | tr '\n' ' ')
		if ! git verify-commit $commits 2>/dev/null
		then
			echo >&2 "Found unsigned or signed-but-unverified commit $local_ref, not pushing"
			exit 1
		fi
	fi
done

exit 0
