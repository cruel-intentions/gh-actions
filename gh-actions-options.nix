{ lib, ...}:
let
  cachixdoc = "https://nix.dev/tutorials/continuous-integration-github-actions#setting-up-github-actions";
  cache = lib.types.submodule {
    options.name = lib.mkOption {
      type        = lib.types.nonEmptyStr;
      default     = null;
      example     = "MyCACHIXCacheName";
      description = ''
        Name of your cache in [CACHIX](${cachixdoc})
      '';
    };
    options.key-name = lib.mkOption {
      type        = lib.types.nullOr lib.types.nonEmptyStr;
      default     = null;
      example     = "CACHIX_SIGNING_KEY";
      description = ''
        Name of GH Secret with [CACHIX SIGNING KEY](${cachixdoc})
      '';
    };
    options.token-name = lib.mkOption {
      type        = lib.types.nullOr lib.types.nonEmptyStr;
      default     = "CACHIX_AUTH_TOKEN";
      example     = "CACHIX_AUTH_TOKEN";
      description = ''
        Name of GH Secret with [CACHIX AUTH TOKEN](${cachixdoc})
      '';
    };
  };
  workflow = lib.types.submodule {
    options.enable = lib.mkEnableOption "Github Actions CI-CD";
    options.cache  = lib.mkOption {
      type        = lib.types.nullOr cache;
      default     = null;
      description = ''
        [CACHIX](${cachixdoc}) binary cache configuration
      '';
      example.name     = "MyCACHIXCacheName";
      example.key-name = "CACHIX_SIGNING_KEY";
    };
    options.ssh-secret-name = lib.mkOption {
      type        = lib.types.nullOr lib.types.nonEmptyStr;
      default     = null;
      example     = "GH_ACTIONS_SSH_KEY";
      description = ''
        Name of GH Secret with PRIVATE SSH KEY
        for more advanced usage try ssh option
      '';
    };
    options.ssh = lib.mkOption {
      type        = lib.types.nullOr (lib.types.attrsOf lib.types.str);
      default     = null;
      description = ''
        https://github.com/marketplace/actions/install-ssh-key
        Config for ssh installation
        There are two reasons to set it
        1. our deploy runs in ssh
        2. we have some private git repository

        In this last case we should add your public key to some user with repository access (in github) or to our private server.
      '';
      example.key = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
    };
    options.env = lib.mkOption {
      description = "env vars for steps";
      default     = {};
      type        = lib.types.submodule {
        options.pre-build = lib.mkOption {
          default     = {};
          description = ''Env variable used by steps'';
          type        = lib.types.attrsOf lib.types.str;
          example.GIPHY_TOKEN = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
        };
        options.build = lib.mkOption {
          default     = {};
          description = ''Env variable used by steps'';
          type        = lib.types.attrsOf lib.types.str;
          example.GIPHY_TOKEN = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
        };
        options.test = lib.mkOption {
          default     = {};
          description = ''Env variable used by steps'';
          type        = lib.types.attrsOf lib.types.str;
          example.GIPHY_TOKEN = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
        };
        options.deploy = lib.mkOption {
          default     = {};
          description = ''Env variable used by steps'';
          type        = lib.types.attrsOf lib.types.str;
          example.GIPHY_TOKEN = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
        };
        options.post-deploy = lib.mkOption {
          default     = {};
          description = ''Env variable used by steps'';
          type        = lib.types.attrsOf lib.types.str;
          example.GIPHY_TOKEN = ''${"$"}{{ secret.GH_ACTIONS_SSH_KEY }}'';
        };
      };
    };
    options.on = lib.mkOption {
      default.push.branches = ["master"];
      example.push.branches = ["master"];
      description = "When this build should be triggered";
      type        = lib.types.attrsOf lib.types.anything;
    };
    options.pre-build = lib.mkOption {
      default     = null;
      description = "Command to run before build";
      example     = "npm i";
      type        = lib.types.nullOr lib.types.nonEmptyStr;
    };
    options.build = lib.mkOption {
      default     = null;
      description = "Command to run as build step";
      example     = "npm run build";
      type        = lib.types.nullOr lib.types.nonEmptyStr;
    };
    options.test = lib.mkOption {
      default     = null;
      description = "Command to run as test step";
      example     = "npm test";
      type        = lib.types.nullOr lib.types.nonEmptyStr;
    };
    options.deploy = lib.mkOption {
      default     = null;
      description = "Command to run as deploy step";
      example     = "aws s3 sync ./build s3://my-bucket";
      type        = lib.types.nullOr lib.types.nonEmptyStr;
    };
    options.post-deploy = lib.mkOption {
      default     = null;
      description = "Command that run after deploy";
      example     = "echo Im done";
      type        = lib.types.nullOr lib.types.nonEmptyStr;
    };
  };
in
{
  options.gh-actions = lib.mkOption {
    default     = {};
    description = "Configure your github actions CI/CD";
    type        = lib.types.attrsOf workflow;
  };
}
