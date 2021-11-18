{ lib, config, ... }:
let cfg = config.gh-actions.ci-cd;
in
{ 
  imports = [ ./gh-actions-options.nix ];
  config.files.yaml."/.github/workflows/ci-cd.yaml" = lib.mkIf cfg.enable {
    on = "push";
    jobs.ci-cd.runs-on = "nixpkgs/nix-flakes";
    jobs.ci-cd.steps = [
      { uses = "actions/checkout@v1"; }
      { run = "nix develop"; }
      # this config comes from arguments
      { run = cfg.pre-build; }
      { run = cfg.build; }
      { run = cfg.test; }
      { run = cfg.deploy; }
    ];
  };
}
