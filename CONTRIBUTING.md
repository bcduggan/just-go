# Contributing

## Commit message format

All commits messages must comply to the [Conventional Commits][] specification with the following extensions.

[Conventional Commits]: https://www.conventionalcommits.org

### Types

Commit messages must use one of the following types, extended from [Angular types][]:

| Type         | Description                                                                                         |
| ------------ | --------------------------------------------------------------------------------------------------- |
| **build**    | Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm) |
| **ci**       | Changes to our CI configuration files and scripts (examples: GitHub Actions)                        |
| **docs**     | Documentation only changes                                                                          |
| **feat**     | A new feature                                                                                       |
| **fix**      | A bug fix                                                                                           |
| **perf**     | A code change that improves performance                                                             |
| **refactor** | A code change that neither fixes a bug nor adds a feature                                           |
| **test**     | Adding missing tests or correcting existing tests                                                   |
| **tooling**  | Changes that affect local tooling behavior (examples: mise, hk, git-cliff, git, taplo, rumdl)       |

[Angular types]: https://github.com/angular/angular/blob/main/contributing-docs/commit-message-guidelines.md#type

### Merge commits

Merge commits must also comply with the [Conventional Commits][] format and use a type from [Types](#types).

## Git workflow

Follow the [GitFlow][] workflow to contribute to this project.

[GitFlow]: https://nvie.com/posts/a-successful-git-branching-model/

### Pull requests

PR names must comply with the [Conventional Commits][] format and use a type from [Types](#types).
