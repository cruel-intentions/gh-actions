{
  config.gh-actions.tag-me.enable = true;
  config.gh-actions.tag-me.deploy = ''
    # tag this project on push to master
    # this a bash script
    git tag v$(convco version --bump)
    git push --tag
  '';
}
