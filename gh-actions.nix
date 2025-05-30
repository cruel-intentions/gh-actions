{ lib, config, ... }:
let
  workflows   = config.gh-actions;
  arrOfIf     = predicate: value: if predicate then [ value ] else [];
  arrOfIfAttr = value: arrOfIf (builtins.isAttrs value);
  arrOfIfStr  = value: arrOfIf (builtins.isString value);
  yaml-file   = name: cfg:
  let
    sshInfo = if(builtins.isString cfg.ssh-secret-name)
    then {
      key         = ''${"$"}{{ secrets.${cfg.ssh-secret-name} }}'';
      known_hosts = "unnecessary";
    }
    else cfg.ssh;
    needs-ssh-key = arrOfIfAttr sshInfo {
      name   = "Install SSH Key";
      uses   = "shimataro/ssh-key-action@d4fffb50872869abe2d9a9098a6d9c5aa7d16be4";
      "with" = sshInfo;
    };
    cmd      = step: "nix develop --command gh-actions-${step}";
    env-vars = env-var: lib.mkIf (builtins.length (builtins.attrNames env-var) > 0) env-var;
    pre-build = arrOfIfStr cfg.pre-build {
      run  = cmd "${name}-pre-build";
      name = "Pre Build";
      env  = env-vars cfg.env.pre-build;
    };
    build = arrOfIfStr cfg.build {
      run  = cmd "${name}-build";
      name = "Build";
      env  = env-vars cfg.env.build;
    };
    test = arrOfIfStr cfg.test {
      run  = cmd "${name}-test";
      name = "Test";
      env  = env-vars cfg.env.test;
    };
    deploy = arrOfIfStr cfg.deploy {
      run  = cmd "${name}-deploy";
      name = "Deploy";
      env  = env-vars cfg.env.deploy;
    };
    post-deploy = arrOfIfStr cfg.post-deploy {
      run  = cmd "${name}-post-deploy";
      name = "Post Deploy";
      env  = env-vars cfg.env.post-deploy;
    };
    checkout = [{
      uses = "actions/checkout@v4";
      "with".fetch-depth = 0;
    }];
    install-cachix = arrOfIf (cfg.cache != null) {
      uses = "cachix/cachix-action@v16";
      "with".name       = cfg.cache.name;
      "with".signingKey = lib.mkIf (cfg.cache.key-name != null) 
        "\${{ secrets.${cfg.cache.key-name} }}";
      "with".authToken  = lib.mkIf (cfg.cache.key-name == null) 
        "\${{ secrets.${cfg.cache.token-name} }}";
      };
    gha-cache = arrOfIf (cfg.gha-cache != null) {
      id   = cfg.gha-cache.id;
      name = cfg.gha-cache.name;
      uses = cfg.gha-cache.uses;
      "with".path = builtins.concatStringsSep "\n" cfg.gha-cache.paths;
      "with".key  = cfg.gha-cache.key;
    };
    install-nix = [{ 
      uses = "cachix/install-nix-action@v31";
      "with".nix_path         = "channel:nixos-24.05";
      "with".extra_nix_config = "access-tokens = github.com=\${{ secrets.GITHUB_TOKEN }}";
    }];
  in
  {
    "/.github/workflows/${name}.yaml" = lib.mkIf cfg.enable {
      on = cfg.on;
      jobs.${name} = {
        runs-on = "ubuntu-latest";
        steps = needs-ssh-key
          ++ checkout
          ++ gha-cache
          ++ install-nix
          ++ install-cachix
          ++ pre-build
          ++ build
          ++ test
          ++ deploy
          ++ post-deploy
        ;
      };
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
  files.alias = lib.foldAttrs lib.mergeAttrs {} aliasses;
  files.yaml = lib.foldAttrs lib.mergeAttrs {} yamls;
}
