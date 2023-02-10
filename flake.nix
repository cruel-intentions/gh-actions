{
  description = "Dev Environment";

  inputs.dsf.url = "github:cruel-intentions/devshell-files";

  outputs = inputs:
  let
    shell = inputs.dsf.lib.mkShell [ ./project.nix ];
    templates.default.path = ./templates/default;
    templates.default.description = "nix flake new -t github:cruel-intentions/gh-actions project";
  in shell // { inherit templates; };
}
