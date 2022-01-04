{ 
  # actions are disable by default, enable it (required)
  gh-actions.tag-me.enable = true;
  # there are 5 optional configurable steps
  # pre-build, build, test, deploy, post-deploy
  # only defined steps goes to yaml file
  gh-actions.tag-me.build = ''
    # tag this project on push to master
    # this is a bash script

    CURR=`convco version`
    NEXT=`convco version --bump`
    MAJOR=`convco version --bump --major`
    MINOR=`convco version --bump --minor`
    PATCH=`convco version --bump --patch`

    LOGS=`git log v$CURR..HEAD --format=oneline|cut -d' ' -f2`
    if echo $CURR|grep -q $NEXT; then
      echo "no reason to update tag" $CURR 
      git log v$CURR..HEAD --format=oneline
      exit 0
    fi

    NEXT=`echo $LOGS | grep -q "feat" && echo MINOR || echo $NEXT`
    NEXT=`echo $LOGS | grep -q "!:"   && echo MAJOR || echo $NEXT`

    git tag v$NEXT

    git push --tag
  '';
}
