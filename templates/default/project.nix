{ 
  # actions are disable by default, enable it (required)
  config.gh-actions.tag-me.enable = true;
  # there are 5 optional configurable steps
  # pre-build, build, test, deploy, post-deploy
  # only defined steps goes to yaml file
  config.gh-actions.tag-me.build = ''
    # tag this project on push to master
    # this is a bash script
    git tag v$(convco version --bump)
    git push --tag
  '';
}
