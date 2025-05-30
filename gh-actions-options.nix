{ lib, ...}:
let
  cachixdoc = "https://nix.dev/tutorials/continuous-integration-github-actions#setting-up-github-actions";
  ghacachedoc = "https://github.com/actions/cache";
  detnix = lib.types.submodule {
    options = {
      extra-conf             = lib.mkOption {};
      force-no-systemd       = lib.mkOption {};
      github-server-url      = lib.mkOption {};
      github-token           = lib.mkOption {};
      init                   = lib.mkOption {};
      kvm                    = lib.mkOption {};
    };
  };
  gha-cache = lib.types.submodule {
    options.id     = lib.mkOption {
      type        = lib.types.nonEmptyStr;
      default     = "cache";
      example     = "my-cache";
      description = ''
        Id to be used in action
      '';
    };
    options.name   = lib.mkOption {
      type        = lib.types.nonEmptyStr;
      default     = "Cache";
      example     = "My Cache";
      description = ''
        Name to be used in this action
      '';
    };
    options.key    = lib.mkOption {
      type        = lib.types.nonEmptyStr;
      default     = "nix-\${{ runner.os }}-\${{ hashFiles('flake.lock') }}";
      example     = "nix-\${{ runner.os }}-\${{ hashFiles('flake.lock') }}";
      description = ''
        Key to used in this cache
      '';
    };
    options.paths  = lib.mkOption {
      type        = lib.types.listOf lib.types.nonEmptyStr;
      default     = ["~/.cache/nix"];
      example     = ["~/.cache/nim"];
      description = ''
        Other paths to cache
      '';
    };
    options.uses   = lib.mkOption {
      type        = lib.types.nonEmptyStr;
      default     = "actions/cache@v4";
      example     = "actions/cache@v4";
      description = ''
        Cache version, default is actions/cache@4
      '';
    };
  };

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
    options.gha-cache  = lib.mkOption {
      type        = lib.types.nullOr gha-cache;
      default     = null;
      description = ''
        [GH Action Cache](${ghacachedoc}) configuration
        By default it caches only ~/.cache/nix
      '';
      example.name = "My cache";
    };
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
