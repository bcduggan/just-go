# tooling

_Reusable hk and mise configurations_

> What are those, hooks?

-- Sal

Reusable hk git hooks, mise tasks, and mise config environments that enforce opinionated development practices with local tooling.

## Table of Contents

- [Background](#background)
- [Usage](#usage)
- [Author](#author)
- [Contributing](#contributing)
- [License](#license)

## Background

I wanted reusable, local tooling to enforce a set of development policies and practices I believe in, like...

- Signed commits and tags
- Conventional commits
- GitFlow
- Auto-updated changelog

...and possibly more.

## Usage

One or more of:

[Import][hk configuration] an hk config file into your project's hk.pkl.

[Include][include mise tasks] a mise tasks directory in your mise tasks sources.

[Vendor (with vendir)][vendir] a mise config environment and supporting mise tasks.

[hk configuration]: https://hk.jdx.dev/configuration.html
[include mise tasks]: https://mise.jdx.dev/tasks/task-configuration.html#task_config.includes
[vendir]: https://carvel.dev/vendir/

TODO: How?

## Author

[Brian Duggan](https://github.com/bcduggan)

## Contributing

See CONTRIBUTING.md

## License

[GPLv3 © Brian Duggan.](LICENSE)
