{ lib, config, ... }:
let
  cfg = config.gh-actions.ci-cd;
  command = "nix develop --command ";
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
      { run = command + cfg.pre-build; name = "Pre Build"; }
      { run = command + cfg.build; name = "Build"; }
      { run = command + cfg.test; name = "Test"; }
      { run = command + cfg.deploy; name = "Deploy"; }
    ];
  };
}
