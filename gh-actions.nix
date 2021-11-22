{ lib, config, ... }:
let
  workflows = config.gh-actions;
  arrOfIf = predicate: value: if predicate then [ value ] else [];
  arrOfIfAttr = value: arrOfIf (builtins.isAttrs value);
  arrOfIfStr = value: arrOfIf (builtins.isString value);
  yaml-file = name: cfg:
  let
    sshInfo = if(builtins.isString cfg.ssh-secret-name)
    then {
      key = ''${"$"}{{ secrets.${cfg.ssh-secret-name} }}'';
      known_hosts = "unnecessary";
    }
    else cfg.ssh;
    needs-ssh-key = arrOfIfAttr sshInfo {
      name = "Install SSH Key";
      uses = "shimataro/ssh-key-action@3c9b0fc6f2d223b8450b02a0445f526350fc73e0";
      "with" = sshInfo;
    };
    cmd = step: "nix develop --command gh-actions-${step}";
    env-vars = env-var: lib.mkIf (builtins.length (builtins.attrNames env-var) > 0) env-var;
    pre-build = arrOfIfStr cfg.pre-build {
      run = cmd "${name}-pre-build";
      name = "Pre Build";
      env = env-vars cfg.env.pre-build;
    };
    build = arrOfIfStr cfg.build {
      run = cmd "${name}-build";
      name = "Build";
      env = env-vars cfg.env.build;
    };
    test = arrOfIfStr cfg.test {
      run = cmd "${name}-test";
      name = "Test";
      env = env-vars cfg.env.test;
    };
    deploy = arrOfIfStr cfg.deploy {
      run = cmd "${name}-deploy";
      name = "Deploy";
      env = env-vars cfg.env.deploy;
    };
    post-deploy = arrOfIfStr cfg.post-deploy {
      run = cmd "${name}-post-deploy";
      name = "Post Deploy";
      env = env-vars cfg.env.post-deploy;
    };
    checkout = [{
        uses = "actions/checkout@v2.4.0";
        "with".fetch-depth = 0;
    }];
    install-nix = [{ 
      uses = "cachix/install-nix-action@v15";
      "with".nix_path = "channel:nixos-unstable";
      "with".extra_nix_config = ''
        access-tokens = github.com=${"$"}{{ secrets.GITHUB_TOKEN }}
      '';
    }];
  in
  {
    "/.github/workflows/${name}.yaml" = lib.mkIf cfg.enable {
      on = cfg.on;
      jobs.ci-cd.runs-on = "ubuntu-latest";
      jobs.ci-cd.steps = needs-ssh-key
        ++ checkout
        ++ install-nix
        ++ pre-build
        ++ build
        ++ test
        ++ deploy
        ++ post-deploy
      ;
    };
  };
  yamls = lib.mapAttrsToList yaml-file workflows;
  alias = name: cfg:
  let ifString = predicate: value: lib.mkIf (predicate && builtins.isString value) value;
  in
  {
    "gh-actions-${name}-pre-build"   = ifString cfg.enable cfg.pre-build;
    "gh-actions-${name}-build"       = ifString cfg.enable cfg.build;
    "gh-actions-${name}-test"        = ifString cfg.enable cfg.test;
    "gh-actions-${name}-deploy"      = ifString cfg.enable cfg.deploy;
    "gh-actions-${name}-post-deploy" = ifString cfg.enable cfg.post-deploy;
  };
  aliasses = lib.mapAttrsToList alias workflows;
in
{ 
  imports = [ ./gh-actions-options.nix ];
  config.files.alias = lib.foldAttrs lib.mergeAttrs {} aliasses;
  config.files.yaml = lib.foldAttrs lib.mergeAttrs {} yamls;
}
