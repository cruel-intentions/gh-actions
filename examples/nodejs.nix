{
  # see packages other than node at https://search.nixos.org/packages
  config.files.cmds.nodejs-14_x = true;
  config.files.alias.push-to-s3 = ''
    # push to s3 bucket $1 if $2 match branch name
    echo $GITHUB_REF | grep -q $2 || exit 0
    echo deploy to $1
    aws s3 sync build s3://$1 --acl public-read --delete
  '';
  # 'ci-cd' is the name of genereted file
  # but it can be any name
  config.gh-actions.ci-cd = {
    enable = true;
    # only run it on master and staging
    on.push.branches = ["master" "staging"];
    # only run it if JS change
    on.push.paths = ["src/**/*.js"];
    # install node modules
    pre-build = "npm install";
    # build our site
    build = "npm run build";
    # deploy you static site
    deploy = ''
      push-to-s3 my-staging-s3-bucket staging
      push-to-s3 my-production-s3-bucket master
    '';
    # deploy needs AWS S3 credentials
    env.deploy.AWS_ACCESS_KEY_ID = ''''${{ secrets.${cfg.secrets.id} }}'';
    env.deploy.AWS_SECRET_ACCESS_KEY = ''''${{ secrets.${cfg.secrets.key} }}'';
    env.deploy.AWS_DEFAULT_REGION = ''''${{ secrets.${cfg.secrets.region} }}'';
    # create tag after deploy if master branch
    post-deploy = ''
      echo $GITHUB_REF | grep -q "master" || exit 0
      git tag v$(convco version --bump)
      git push --tag
    '';
  };
}
