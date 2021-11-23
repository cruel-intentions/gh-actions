# Devshel GH-Actions Module
## About

This is a module for [Devshell](https://github.com/numtide/devshell) that help you write your github actions yaml in [Nix](https://nixos.org/guides/how-nix-works.html)

If you don't know what is all about, see [Devshell Files Introduction](https://github.com/cruel-intentions/devshell-files).

tl;dr: It make our config files reusable and modular

## Installation

- Same as for [devshell-files](/cruel-intentions/devshell-files#instructions)

## Usage

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
nix flake new -t github:cruel-intentions/gh-files ./
git add flake.nix, flake.lock project.nix
```

Configuring existing Nix projects:

If you are using devshell-files is easy like above

```nix
{
  description = "Dev Environment";

  inputs.dsf.url = "github:cruel-intentions/devshell-files";
  inputs.gha.url = "github:cruel-intentions/gh-actions";
  # for private repository use git url
  # inputs.gha.url = "git+ssh://git@github.com/cruel-intentions/gh-actions.git";

  outputs = inputs: inputs.dsf.lib.mkShell [
    "${inputs.gha}/gh-actions.nix"
    ./project.nix
  ];
}
```

If not see [Devshell docs](https://numtide.github.io/devshell/)
