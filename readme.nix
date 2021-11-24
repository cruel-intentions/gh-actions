{
  config.files.text."/README.md" = builtins.concatStringsSep "\n" [
    "# Devshell GH-Actions Module"
    (builtins.readFile ./docs/about.md)
    (builtins.readFile ./docs/usage.md)
    (builtins.import   ./docs/examples.nix)
    (builtins.readFile ./docs/options.md)
  ];
}
