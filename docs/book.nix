let
  project = "gh-actions";
  author = "cruel-intentions";
  org-url = "https://github.com/${author}";
  edit-path = "${org-url}/${project}/edit/master/guide/{path}";
in
{
  config.files.mdbook.enable = true;
  config.files.mdbook.authors = ["Cruel Intentions <${org-url}>"];
  config.files.mdbook.language = "en";
  config.files.mdbook.gh-author = author;
  config.files.mdbook.gh-project = project;
  config.files.mdbook.multilingual = false;
  config.files.mdbook.title = "Github Actions YAML Generator";
  config.files.mdbook.output.html.fold.enable = true;
  config.files.mdbook.output.html.no-section-label = true;
  config.files.mdbook.output.html.site-url = "/${project}/";
  config.files.mdbook.output.html.git-repository-icon = "fa-github";
  config.files.mdbook.output.html.git-repository-url = "${org-url}/${project}";
  config.files.mdbook.output.html.edit-url-template = edit-path;
  config.files.mdbook.summary = builtins.readFile ./summary.md;

  config.files.text."/gh-pages/src/about.md" = builtins.readFile ./about.md;
  config.files.text."/gh-pages/src/usage.md" = builtins.readFile ./usage.md;
  config.files.text."/gh-pages/src/examples.md" = builtins.import ./examples.nix;
  config.files.docs."/gh-pages/src/options.md".modules = [ ../gh-actions-options.nix ];
  config.files.gitignore.pattern."gh-pages" = true;

  config.gh-actions.gh-pages.enable = true;
  config.gh-actions.gh-pages.build = ''
    git config --global user.name $GITHUB_ACTOR
    git config --global user.email $GITHUB_ACTOR@users.noreply.github.com
    publish-as-gh-pages
  '';
}
