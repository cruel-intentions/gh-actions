{ lib, config, ... }:
let
  cfg = config.gh-actions.ci-cd;
  cmd = step: "nix develop --command gh-actions-ci-cd-${step}";
  needs-ssh-key = if builtins.isNull cfg.ssh then []
    else [{
      name = "Install SSH Key";
      uses = "shimataro/ssh-key-action@3c9b0fc6f2d223b8450b02a0445f526350fc73e0";
      "with" = cfg.ssh;
    }];
in
{ 
  imports = [ ./gh-actions-options.nix ];
  config.files.alias = lib.mkIf cfg.enable {
    gh-actions-ci-cd-pre-build = cfg.pre-build;
    gh-actions-ci-cd-build = cfg.build;
    gh-actions-ci-cd-test = cfg.test;
    gh-actions-ci-cd-deploy = cfg.deploy;
  };
  config.files.yaml."/.github/workflows/ci-cd.yaml" = lib.mkIf cfg.enable {
    on = cfg.on;
    jobs.ci-cd.runs-on = "ubuntu-latest";
    jobs.ci-cd.steps = needs-ssh-key ++ [
      { uses = "actions/checkout@v2.4.0"; }
      { 
        uses = "cachix/install-nix-action@v15";
        "with".nix_path = "channel:nixos-unstable";
        "with".extra_nix_config = ''
          access-tokens = github.com=${"$"}{{ secrets.GITHUB_TOKEN }}
        '';
      }
      # this config comes from arguments
      { run = cmd "pre-build"; name = "Pre Build"; }
      { run = cmd "build"; name = "Build"; }
      { run = cmd "test"; name = "Test"; }
      { run = cmd "deploy"; name = "Deploy"; }
    ];
  };
}
