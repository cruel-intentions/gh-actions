{
  imports = [ ./gh-actions.nix ];

  # enable .gitignore creation
  config.files.gitignore.enable = true;
  # copy contents from https://github.com/github/gitignore
  # to our .gitignore
  config.files.gitignore.template."Global/Archives" = true;
  config.files.gitignore.template."Global/Backup" = true;
  config.files.gitignore.template."Global/Diff" = true;
  # now we can use 'convco' command https://convco.github.io
  config.files.cmds.convco = true;
  # now we can use 'featw' command as alias to convco
  config.files.alias.feat = ''convco commit --feat $@'';
  config.files.alias.fix = ''convco commit --fix $@'';
  config.files.alias.chore = ''convco commit --chore $@'';

  # LICENSE file creation
  # using templates from https://github.com/spdx/license-list-data
  config.files.license.enable = true;
  config.files.license.spdx.name = "MIT";
  config.files.license.spdx.vars.year = "2021";
  config.files.license.spdx.vars."copyright holders" = "Cruel Intentions";

  config.gh-actions.ci-cd.enable = true;
  config.gh-actions.ci-cd.build = "menu";
  config.gh-actions.ci-cd.deploy = ''
    git tag v$(convco version --bump)
    git push --tag
  '';
}
