#!/usr/bin/sh
#MISE env._.source = { path = "../.env" }

set -euf

JQ_N="jq --null-input"
JQ_NRO="$JQ_N --raw-output"
# X-Github-Next-Global-ID:1 explanation:
# https://github.blog/developer-skills/github/exploring-github-cli-how-to-interact-with-githubs-graphql-api-endpoint/#basic-query-example
# https://docs.github.com/en/graphql/guides/migrating-graphql-global-node-ids
GH_GQL="gh api graphql -H X-GitHub-Next-Global-ID:1"
GQL_DIR="$MISE_PROJECT_ROOT/.github/settings/rulesets"

ruleset_nodes() {
  local HAS_NEXT_PAGE=true
  local END_CURSOR=null
  local NODES_JSON="[]"

  while [ "$HAS_NEXT_PAGE" = "true" ]; do
    local RESULT_JSON="$($GH_GQL -F query="@$GQL_DIR/get.gql" -f owner="$REPO_OWNER" -f name="$REPO_NAME" -F first=100 -f endCursor="$END_CURSOR")"
    HAS_NEXT_PAGE="$($JQ_NRO --argjson result "$RESULT_JSON" '$result.data.repository.rulesets.pageInfo.hasNextPage')"
    END_CURSOR="$($JQ_NRO --argjson result "$RESULT_JSON" '$result.data.repository.rulesets.pageInfo.endCursor')"
    NODES_JSON="$($JQ_N --argjson nodes "$NODES_JSON" --argjson result "$RESULT_JSON" '$nodes + $result.data.repository.rulesets.nodes')"
  done

  $JQ_NRO --argjson nodes "$NODES_JSON" '[ $nodes[].id ]'
}

delete_rulesets_gql() {
  local NODES="$1"
  echo 'mutation() {'
  $JQ_NRO --argjson nodes "$NODES" '$nodes[] as $node | "  \($node|gsub("-"; "_")): deleteRepositoryRuleset(input: { repositoryRulesetId: \"\($node)\" }) { clientMutationId }"'
  echo '}'
}

delete_rulesets() {
  local NODES="$(ruleset_nodes)"
  if [ "$($JQ_NRO --argjson nodes "$NODES" '$nodes | length')" -gt 0 ]; then
    $GH_GQL -F query="$(delete_rulesets_gql "$NODES")"
  fi
}

delete_rulesets

$GH_GQL -F query="@$GQL_DIR/create.gql" -F sourceId="$REPO_ID"
