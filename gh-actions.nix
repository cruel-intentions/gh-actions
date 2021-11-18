{ lib, config, ... }:
let
  cfg = config.gh-actions.ci-cd;
  devshell = "nix develop\n";
in
{ 
  imports = [ ./gh-actions-options.nix ];
  config.files.yaml."/.github/workflows/ci-cd.yaml" = lib.mkIf cfg.enable {
    on = "push";
    jobs.ci-cd.runs-on = "ubuntu-latest";
    jobs.ci-cd.steps = [
      { uses = "actions/checkout@v2.4.0"; }
      { 
        uses = "cachix/install-nix-action@v15";
        "with".nix_path = "channel:nixos-unstable";
        "with".extra_nix_config = ''
          access-tokens = github.com=${"$"}{{ secrets.GITHUB_TOKEN }}
        '';
      }
      # this config comes from arguments
      { run = devshell + cfg.pre-build; }
      { run = devshell + cfg.build; }
      { run = devshell + cfg.test; }
      { run = devshell + cfg.deploy; }
    ];
  };
}
