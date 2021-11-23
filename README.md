# Devshel GH-Actions Module
## About

This is a module for [Devshell](https://github.com/numtide/devshell) that help you write your github actions yaml in [Nix](https://nixos.org/guides/how-nix-works.html)

If you don't know what is all about, see [Devshell Files Introduction](https://github.com/cruel-intentions/devshell-files).

tl;dr: It make our config files reusable and modular

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

## Examples

The most basic example is used by this project to tag it self

```nix
{
  config.gh-actions.tag-me.enable = true;
  config.gh-actions.tag-me.deploy = ''
    # tag this project on push to master
    # this a bash script
    git tag v$(convco version --bump)
    git push --tag
  '';
}

```

<details>
<summary>It generate our .github/workflows/tag-me.yaml</summary>
<br>
```yaml
jobs:
  tag-me:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2.4.0
        with:
          fetch-depth: 0
      - uses: cachix/install-nix-action@v15
        with:
          extra_nix_config: |
            access-tokens = github.com=${{ secrets.GITHUB_TOKEN }}
          nix_path: channel:nixos-unstable
      - name: Deploy
        run: nix develop --command gh-actions-tag-me-deploy
"on":
  push:
    branches:
      - master

```
</details>


We should commit this yaml file because github can only read commited yaml files.
