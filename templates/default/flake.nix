{
  description = "Dev Environment";

  inputs.dsf.url = "github:cruel-intentions/devshell-files";
  inputs.gha.url = "github:cruel-intentions/gh-actions";

  outputs = inputs: inputs.dsf.lib.mkShell [
    # Github Actions YAML helper
    # https://cruel-intentions.github.io/gh-actions/options.html
    "${inputs.gha}/gh-actions.nix"

    # Github Issue Forms YAML helper
    # "${inputs.gha}/gh-form.nix"

    # Github Dependabot YAML helper
    # https://cruel-intentions.github.io/gh-actions/options-dependabot.html
    # "${inputs.gha}/dependabot.nix"
    ./project.nix
  ];
}
