{ lib, ...}:
{
  options.gh-actions.ci-cd = lib.mkOption {
    type = lib.types.submodule {
      options.enable = lib.mkEnableOption "Github Actions CI-CD";
      options.pre-build = lib.mkOption {
        type = lib.types.str;
        default = "echo pre-building";
        example = "npm i";
        description = "Command to run before build";
      };
      options.build = lib.mkOption {
        type = lib.types.str;
        default = "echo building";
        example = "npm run build";
        description = "Command to run as build step";
      };
      options.test = lib.mkOption {
        type = lib.types.str;
        default = "echo testing";
        example = "npm test";
        description = "Command to run as test step";
      };
      options.deploy = lib.mkOption {
        type = lib.types.str;
        default = "echo deploying";
        example = "aws s3 sync ./build s3://my-bucket";
        description = "Command to run as deploy step";
      };
    };
    default = {};
    description = "Configure your github actions CI/CD";
  };
}
