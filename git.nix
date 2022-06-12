{
  # enable .gitignore creation
  files.gitignore.enable = true;
  # copy contents from https://github.com/github/gitignore
  # to our .gitignore
  files.gitignore.pattern.".direnv"          = true;
  files.gitignore.pattern.".envrc"           = true;
  files.gitignore.template."Global/Archives" = true;
  files.gitignore.template."Global/Backup"   = true;
  files.gitignore.template."Global/Diff"     = true;

  # now we can use 'convco' command https://convco.github.io
  files.cmds.convco = true;
  # now we can use 'featw' command as alias to convco
  files.alias.chore = ''convco commit --chore $@'';
  files.alias.docs  = ''convco commit --docs $@'';
  files.alias.feat  = ''convco commit --feat $@'';
  files.alias.fix   = ''convco commit --fix $@'';
}
