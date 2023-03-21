{
  packages = ["awscli" "convco" "nodejs"];
  # 'ci-cd' is the name of genereted file
  # but we are free to change it
  # In previous example we named as 'tag-it'
  gh-actions.ci-cd.enable           = true;
  gh-actions.ci-cd.on.push.branches = ["master" "staging"]; # only run it on master and staging
  gh-actions.ci-cd.on.push.paths    = ["src/**/*.js"];      # only run it if JS change
  gh-actions.ci-cd.pre-build        = "npm install";        # install dependencies
  gh-actions.ci-cd.build            = "npm run build";      # build our site
  gh-actions.ci-cd.deploy           = ''
    push-to-s3 my-staging-s3-bucket staging
    push-to-s3 my-production-s3-bucket master
  '';                                                       # deploy you static site
  # my needs AWS S3 credentials
  gh-actions.ci-cd.env.deploy.AWS_ACCESS_KEY_ID     = "\${{ secrets.AWS_ACCESS_KEY_ID     }}";
  gh-actions.ci-cd.env.deploy.AWS_SECRET_ACCESS_KEY = "\${{ secrets.AWS_SECRET_ACCESS_KEY }}";
  gh-actions.ci-cd.env.deploy.AWS_DEFAULT_REGION    = "\${{ secrets.AWS_DEFAULT_REGION    }}";
  # create tag after deploy if master branch
  gh-actions.ci-cd.post-deploy = ''
    echo $GITHUB_REF | grep -q "master" || exit 0
    git tag v$(convco version --bump)
    git push --tag
  '';
  # We could also configure Cachix
  # https://www.cachix.org/
  gh-actions.ci-cd.cache.name = "yourCacheName";
  # git hub secret with cache token
  # gh-actions.ci-cd.cache.token-name = "CACHIX_AUTH_TOKEN"  # default value
  # git hub secret with cache signing key
  # gh-actions.ci-cd.cache.key-name   = null                 # default value
  # nodejs needs to be available
  # But it could be ruby, python, rust...
  # See more 80.000 packages at https://search.nixos.org/packages
  files.alias.push-to-s3 = ''
    # push to s3 bucket $1 if $2 match branch name
    echo $GITHUB_REF | grep -q $2 || exit 0
    echo deploy to $1
    aws s3 sync build s3://$1 --acl public-read --delete
  '';
}
