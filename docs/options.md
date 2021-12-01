## Options

For more updated documentation see auto generated from source at [https://cruel-intentions.github.io/gh-actions/options.html](https://cruel-intentions.github.io/gh-actions/options.html)

##### config.gh-actions

Configure your github actions

**Type**
_attrsOf workflows_

It means an hashmap (object of JS) with any key (where te key is name of file) and has _workflows_ as value

**Example**

```nix
{
  config.gh-actions.MY-FILE-NAME = {
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
  config.gh-actions.MY-FILE-NAME = { enable = true; };
  # it is same as
  # config.gh-actions.MY-FILE-NAME.enable = true;
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
  config.gh-actions.MY-FILE-NAME.enable = true;
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
  config.gh-actions.MY-FILE-NAME.on.push.branches = ["staging"];
```

###### pre-build

Bash script of our pre-build step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  config.gh-actions.MY-FILE-NAME.pre-build = "npm i";
```

###### build

Bash script of our build step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  config.gh-actions.MY-FILE-NAME.build = "npm run build";
```

###### test

Bash script of our test step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  config.gh-actions.MY-FILE-NAME.test = "npm run test";
```

###### deploy

Bash script of our deploy step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  config.gh-actions.MY-FILE-NAME.deploy = "aws s3 sync ./build s3://my-bucket";
```

###### post-deploy

Bash script of our post deploy step

**Type**
_nullOr nonEmptyStr_

**Default**
_null_

**Example**

```nix
  config.gh-actions.MY-FILE-NAME.post-deploy = "echo uhhuuuuu";
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
  config.gh-actions.MY-FILE-NAME.ssh-secret-name = "MY_GH_SSH_SECRET_NAME";
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
  config.gh-actions.MY-FILE-NAME.ssh.key = ''${"$"}{{ secret.MY_GH_SSH_SECRET_NAME }}'';
```

###### env

When any of your actions need env variable this suboption could be defined


**Type**
_submodule_

**Default**
_{}_

**Example**

```nix
  config.gh-actions.MY-FILE-NAME.env = {
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


