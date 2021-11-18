{ lib, config, ... }:
let
  cfg = config.gh-actions.ci-cd;
  cmd = step: "nix develop --command gh-actions-ci-cd-${step}";
  ifString = value: lib.mkIf (builtins.isString value) value;
  arrOfIf = predicate: value: if predicate then [ value ] else [];
  arrOfIfAttr = value: arrOfIf (builtins.isAttrs value);
  arrOfIfStr = value: arrOfIf (builtins.isString value);
  needs-ssh-key = arrOfIfAttr cfg.ssh {
    name = "Install SSH Key";
    uses = "shimataro/ssh-key-action@3c9b0fc6f2d223b8450b02a0445f526350fc73e0";
    "with" = cfg.ssh;
  };
in
{ 
  imports = [ ./gh-actions-options.nix ];
  config.gh-actions.ci-cd.ssh = lib.mkIf (builtins.isString cfg.ssh-secret-name) {
    key = ''${"$"}{{ secrets.${cfg.ssh-secret-name} }}'';
    known_hosts = "unnecessary";
  };
  config.files.alias = lib.mkIf cfg.enable {
    gh-actions-ci-cd-pre-build = ifString cfg.pre-build;
    gh-actions-ci-cd-build = ifString cfg.build;
    gh-actions-ci-cd-test = ifString cfg.test;
    gh-actions-ci-cd-deploy = ifString cfg.deploy;
    gh-actions-ci-cd-post-deploy = ifString cfg.post-deploy;
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
    ]
      # this config comes from arguments
      ++ (arrOfIfStr cfg.pre-build { run = cmd "pre-build"; name = "Pre Build"; })
      ++ (arrOfIfStr cfg.build { run = cmd "build"; name = "Build"; })
      ++ (arrOfIfStr cfg.test { run = cmd "test"; name = "Test"; })
      ++ (arrOfIfStr cfg.deploy { run = cmd "deploy"; name = "Deploy"; })
      ++ (arrOfIfStr cfg.post-deploy { run = cmd "post-deploy"; name = "Pos eploy"; })
    ;
  };
}
