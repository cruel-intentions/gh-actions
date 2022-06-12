let
  author    = "cruel-intentions";
  edit-path = "${org-url}/${project}/edit/master/guide/{path}";
  org-url   = "https://github.com/${author}";
  project   = "devshell-files";
in
{
  imports = [
    ./dependabot.nix
    ./docs/book.nix
    ./gh-actions.nix
    ./gh-form.nix
    ./git.nix
    ./license.nix
    ./readme.nix
    ./templates/default/issues.nix
    ./templates/default/project.nix
  ];

  devshell.motd = " ";
  files.direnv.enable = true;
  gh-form = import ./.github/form.nix;
}
