## Installation

- Same as for [devshell-files](/cruel-intentions/devshell-files#instructions)

### Setup configuration

Configuring new projects:

```sh
nix flake new -t github:cruel-intentions/gh-actions my-project
cd my-project
git init
nix develop --build
git add .
```

Configuring existing projects:

```sh
nix flake new -t github:cruel-intentions/gh-actions ./
nix develop --build
git add flake.nix flake.lock project.nix
```

Configuring existing Nix projects:

See [Devshell-files docs](https://github.com/cruel-intentions/devshell-files#sharing-our-module)
