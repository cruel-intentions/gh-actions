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
  # actions are disable by default, enable it (required)
  config.gh-actions.tag-me.enable = true;
  # there are 5 optional configurable steps
  # pre-build, build, test, deploy, post-deploy
  # only defined steps goes to yaml file
  config.gh-actions.tag-me.build = ''
    # tag this project on push to master
    # this is a bash script
    git tag v$(convco version --bump)
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
      - uses: actions/checkout@v2.4.0
        with:
          fetch-depth: 0
      - uses: cachix/install-nix-action@v15
        with:
          extra_nix_config: |
            access-tokens = github.com=${{ secrets.GITHUB_TOKEN }}
          nix_path: channel:nixos-unstable
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
  # 'ci-cd' is the name of genereted file
  # but we are free to change it
  # In previous example we named as 'tag-it'
  config.gh-actions.ci-cd = {
    enable = true;
    # only run it on master and staging
    on.push.branches = ["master" "staging"];
    # only run it if JS change
    on.push.paths = ["src/**/*.js"];
    # install dependencies
    pre-build = "npm install";
    # build our site
    build = "npm run build";
    # deploy you static site
    deploy = ''
      push-to-s3 my-staging-s3-bucket staging
      push-to-s3 my-production-s3-bucket master
    '';
    # deploy needs AWS S3 credentials
    env.deploy.AWS_ACCESS_KEY_ID = ''${"$"}{{ secrets.AWS_ACCESS_KEY_ID} }}'';
    env.deploy.AWS_SECRET_ACCESS_KEY = ''${"$"}{{ secrets.AWS_SECRET_ACCESS_KEY }}'';
    env.deploy.AWS_DEFAULT_REGION = ''${"$"}{{ secrets.AWS_DEFAULT_REGION }}'';
    # create tag after deploy if master branch
    post-deploy = ''
      echo $GITHUB_REF | grep -q "master" || exit 0
      git tag v$(convco version --bump)
      git push --tag
    '';
  };
  # nodejs needs to be available
  # But it could be ruby, python, rust...
  # See more 80.000 packages at https://search.nixos.org/packages
  config.files.cmds.nodejs-14_x = true;
  config.files.alias.push-to-s3 = ''
    # push to s3 bucket $1 if $2 match branch name
    echo $GITHUB_REF | grep -q $2 || exit 0
    echo deploy to $1
    aws s3 sync build s3://$1 --acl public-read --delete
  '';
}


```

## Options

##### options.gh-actions

Configure your github actions

**Type**
_attrsOf workflows_

It means an hashmap (object of JS) with any key (where te key is name of file) and has _workflows_ as value

**Example**

```nix
{
  options.gh-actions.MY-FILE-NAME = {
    # write your WORKFLOW here
  };
}
```


###### workflows

**Type**
_submodule_

It means is a container of other sub options (if we where Object Oriented developers it is similar to a Class)

**Example**

```nix
{
  options.gh-actions.MY-FILE-NAME = { enable = true; };
  # it is same as
  # options.gh-actions.MY-FILE-NAME.enable = true;
}
```

###### enable

Enable or disable our workflows

**Type**
_bool_

**Default**
_false_

**Example**

```nix
{
  options.gh-actions.MY-FILE-NAME.enable = true;
}
```


###### on

Determines when our action should run
See [github action](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#on) documentation

**Type**
_attrsOf anything_

**Default**
_{ push.branches = [ "master" ]; }_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.on.push.branches = ["staging"];
```

###### pre-build

Bash script of our pre-build step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.pre-build = "npm i";
```

###### build

Bash script of our build step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.build = "npm run build";
```

###### test

Bash script of our test step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.test = "npm run test";
```

###### deploy

Bash script of our deploy step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.deploy = "aws s3 sync ./build s3://my-bucket";
```

###### post-deploy

Bash script of our post deploy step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.post-deploy = "echo uhhuuuuu";
```

###### ssh-secret-name

The name of your Github Secret with SSH Private Key

This will configure ssh if your deploy need it

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.ssh-secret-name = "MY_GH_SSH_SECRET_NAME";
```

###### ssh

If we need more flexibility for SSH configuration

See for options https://github.com/marketplace/actions/install-ssh-key

**Type**
_nullOr (attrOf str)_

**Default**
_null_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.ssh.key = ''${"$"}{{ secret.MY_GH_SSH_SECRET_NAME }}'';
```

###### env

When any of your actions need env variable this suboption could be defined


**Type**
_submodule_

**Default**
_{}_

**Example**

```nix
  options.gh-actions.MY-FILE-NAME.env = {
    pre-build = {
      ENV_VAR_NAME = "ENV_VAR_VALUE";
      OTHER_ENV_VAR_NAME = "OTHER_ENV_VAR_VALUE";
    };
    build.ENV_VAR_NAME = "ENV_VAR_VALUE";
    test.ENV_VAR_NAME = "ENV_VAR_VALUE";
    deploy.ENV_VAR_NAME = "ENV_VAR_VALUE";
    post-deploy.ENV_VAR_NAME = "ENV_VAR_VALUE";
    post-deploy.OTHER_ENV_VAR_NAME = "OTHER_ENV_VAR_VALUE";
  };
```


