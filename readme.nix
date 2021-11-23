{
  config.files.text."/README.md" = builtins.concatStringsSep "\n" [
    "# Devshel GH-Actions Module"
    (builtins.readFile ./docs/about.md)
    (builtins.readFile ./docs/usage.md)
  ];
}
