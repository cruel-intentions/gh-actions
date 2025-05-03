# Devshell GH-Actions Module
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


#### Basic

The most basic example is used by this project to tag it

```nix
# project.nix
{
  packages = ["convco"];
  # actions are disable by default, enable it (required)
  gh-actions.tag-me.enable = true;
  # there are 5 optional configurable steps
  # pre-build, build, test, deploy, post-deploy
  # only defined steps goes to yaml file
  gh-actions.tag-me.build = ''
    # tag this project on push to master
    # this is a bash script

    CURR=`convco  version`
    NEXT=`convco  version --bump`
    MAJOR=`convco version --bump --major`
    MINOR=`convco version --bump --minor`
    PATCH=`convco version --bump --patch`

    LOGS=`git log v$CURR..HEAD --format=oneline|cut -d' ' -f2`
    if echo $CURR|grep -q $NEXT; then
      echo "no reason to update tag" $CURR 
      git log v$CURR..HEAD --format=oneline
      exit 0
    fi

    NEXT=`echo $LOGS | grep -q "feat" && echo $MINOR || echo $NEXT`
    NEXT=`echo $LOGS | grep -q "!:"   && echo $MAJOR || echo $NEXT`

    git tag v$NEXT

    git push --tag
  '';
}

```

<details>
<summary>It generate our .github/workflows/tag-me.yaml (click to expand)</summary>
<br>


```yaml
# .github/workflows/tag-me.yaml
jobs:
  tag-me:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - uses: cachix/install-nix-action@v31
        with:
          extra_nix_config: access-tokens = github.com=${{ secrets.GITHUB_TOKEN }}
          nix_path: channel:nixos-24.05
      - name: Build
        run: nix develop --command gh-actions-tag-me-build
"on":
  push:
    branches:
      - master

```


</details>


We should commit this yaml file because github can only read commited yaml files.


#### Complex


This is a more complex example

```nix
# examples/nodejs.nix
{
  packages = ["awscli" "convco" "nodejs"];
  # 'ci-cd' is the name of genereted file
  # but we are free to change it
  # In previous example we named as 'tag-it'
  gh-actions.ci-cd.enable           = true;
  gh-actions.ci-cd.on.push.branches = ["master" "staging"]; # only run it on master and staging
  gh-actions.ci-cd.on.push.paths    = ["src/**/*.js"];      # only run it if JS change
  gh-actions.ci-cd.pre-build        = "npm install";        # install dependencies
  gh-actions.ci-cd.build            = "npm run build";      # build our site
  gh-actions.ci-cd.deploy           = ''
    push-to-s3 my-staging-s3-bucket staging
    push-to-s3 my-production-s3-bucket master
  '';                                                       # deploy you static site
  # my needs AWS S3 credentials
  gh-actions.ci-cd.env.deploy.AWS_ACCESS_KEY_ID     = "\${{ secrets.AWS_ACCESS_KEY_ID     }}";
  gh-actions.ci-cd.env.deploy.AWS_SECRET_ACCESS_KEY = "\${{ secrets.AWS_SECRET_ACCESS_KEY }}";
  gh-actions.ci-cd.env.deploy.AWS_DEFAULT_REGION    = "\${{ secrets.AWS_DEFAULT_REGION    }}";
  # create tag after deploy if master branch
  gh-actions.ci-cd.post-deploy = ''
    echo $GITHUB_REF | grep -q "master" || exit 0
    git tag v$(convco version --bump)
    git push --tag
  '';
  # We could also configure Cachix
  # https://www.cachix.org/
  gh-actions.ci-cd.cache.name = "yourCacheName";
  # git hub secret with cache token
  # gh-actions.ci-cd.cache.token-name = "CACHIX_AUTH_TOKEN"  # default value
  # git hub secret with cache signing key
  # gh-actions.ci-cd.cache.key-name   = null                 # default value
  # nodejs needs to be available
  # But it could be ruby, python, rust...
  # See more 80.000 packages at https://search.nixos.org/packages
  files.alias.push-to-s3 = ''
    # push to s3 bucket $1 if $2 match branch name
    echo $GITHUB_REF | grep -q $2 || exit 0
    echo deploy to $1
    aws s3 sync build s3://$1 --acl public-read --delete
  '';
}


```

## See also

* [Nix](https://nixos.org/)
* [DevShell](https://github.com/numtide/devshell)
* [Devshell-files](https://github.com/cruel-intentions/devshell-files)
* [Arncmx/Ci](https://github.com/arcnmx/ci)
* [Home Manager](https://github.com/nix-community/home-manager)
* [Nix Ecosystem](https://nixos.wiki/wiki/Nix_Ecosystem)
* [Makes](https://github.com/fluidattacks/makes)
* [Nix.Dev](https://nix.dev/)
* [Nixology](https://www.youtube.com/watch?v=NYyImy-lqaA&list=PLRGI9KQ3_HP_OFRG6R-p4iFgMSK1t5BHs)

