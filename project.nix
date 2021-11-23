{
  imports = [
    ./gh-actions.nix
    ./git.nix
    ./license.nix
    ./readme.nix
  ];

  config.gh-actions.tag-me.enable = true;
  config.gh-actions.tag-me.deploy = ''
    git tag v$(convco version --bump)
    git push --tag
  '';
}
