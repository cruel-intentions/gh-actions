let
  project = "devshell-files";
  author = "cruel-intentions";
  org-url = "https://github.com/${author}";
  edit-path = "${org-url}/${project}/edit/master/guide/{path}";
in
{
  imports = [
    ./gh-actions.nix
    ./dependabot.nix
    ./git.nix
    ./license.nix
    ./readme.nix
    ./templates/default/project.nix
    ./docs/book.nix
  ];
}
