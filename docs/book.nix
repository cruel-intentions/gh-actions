let
  project = "gh-actions";
  author = "cruel-intentions";
  org-url = "https://github.com/${author}";
  edit-path = "${org-url}/${project}/edit/master/guide/{path}";
in
{
  files.mdbook.enable = true;
  files.mdbook.authors = ["Cruel Intentions <${org-url}>"];
  files.mdbook.language = "en";
  files.mdbook.gh-author = author;
  files.mdbook.gh-project = project;
  files.mdbook.multilingual = false;
  files.mdbook.title = "Github Actions YAML Generator";
  files.mdbook.output.html.fold.enable = true;
  files.mdbook.output.html.no-section-label = true;
  files.mdbook.output.html.site-url = "/${project}/";
  files.mdbook.output.html.git-repository-icon = "fa-github";
  files.mdbook.output.html.git-repository-url = "${org-url}/${project}";
  files.mdbook.output.html.edit-url-template = edit-path;
  files.mdbook.summary = builtins.readFile ./summary.md;

  files.text."/gh-pages/src/about.md" = builtins.readFile ./about.md;
  files.text."/gh-pages/src/usage.md" = builtins.readFile ./usage.md;
  files.text."/gh-pages/src/see-also.md" = builtins.readFile ./see-also.md;
  files.text."/gh-pages/src/examples.md" = builtins.import ./examples.nix;
  files.docs."/gh-pages/src/options.md".modules = [ ../gh-actions-options.nix ];
  files.docs."/gh-pages/src/options-dependabot.md".modules = [ ../dependabot-options.nix ];
  files.docs."/gh-pages/src/options-gh-form.md".modules = [ ../gh-form.nix ];
  files.gitignore.pattern."gh-pages" = true;
  gh-actions.gh-pages.enable = true;
  gh-actions.gh-pages.build = ''publish-as-gh-pages'';
}
