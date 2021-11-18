{ lib, config, ... }:
let cfg = config.gh-actions.ci-cd;
in
{ 
  imports = [ ./gh-actions-options.nix ];
  config.files.yaml."/.github/workflows/ci-cd.yaml" = lib.mkIf cfg.enable {
    on = "push";
    jobs.ci-cd.runs-on = "ubuntu-latest";
    jobs.ci-cd.steps = [
      { uses = "actions/checkout@v1"; }
      { uses = "cachix/install-nix-action@v13"; "with".nix_path = "channel:nixos-unstable"; }
      { run = "nix develop"; }
      # this config comes from arguments
      { run = cfg.pre-build; }
      { run = cfg.build; }
      { run = cfg.test; }
      { run = cfg.deploy; }
    ];
  };
}
