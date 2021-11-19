{ lib, ...}:
let
  workflow = lib.types.submodule {
    options.enable = lib.mkEnableOption "Github Actions CI-CD";
    options.ssh-secret-name = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "GH_ACTIONS_SSH_KEY";
      description = ''
        Name of GH Secret with PRIVATE SSH KEY
        for more advanced usage try ssh option
      '';
    };
    options.ssh = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
      default = null;
      example.key = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
      description = ''
        https://github.com/marketplace/actions/install-ssh-key
        Config for ssh installation
        There are two reasons to set it
        1. our deploy runs in ssh
        2. we have some private git repository

        In this last case we should add your public key to some user with repository access (in github) or to our private server.
      '';
    };
    options.env = lib.mkOption {
      type = lib.types.nullOr (lib.types.attrsOf lib.types.str);
      default = null;
      example.GIPHY_TOKEN = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
      description = ''Env variable used by steps'';
    };
    options.on = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default.push.branches = ["master"];
      example.push.branches = ["master"];
      description = "When this build should be triggered";
    };
    options.pre-build = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "npm i";
      description = "Command to run before build";
    };
    options.build = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "npm run build";
      description = "Command to run as build step";
    };
    options.test = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "npm test";
      description = "Command to run as test step";
    };
    options.deploy = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "aws s3 sync ./build s3://my-bucket";
      description = "Command to run as deploy step";
    };
    options.post-deploy = lib.mkOption {
      type = lib.types.nullOr lib.types.nonEmptyStr;
      default = null;
      example = "echo Im done";
      description = "Command that run after deploy";
    };
  };
in
{
  options.gh-actions = lib.mkOption {
    type = lib.types.attrsOf workflow;
    default = {};
    description = "Configure your github actions CI/CD";
  };
}
