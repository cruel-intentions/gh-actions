{ config, lib, ... }:
let
  docs-url = "https://docs.github.com/en/code-security/supply-chain-security/keeping-your-dependencies-updated-automatically/configuration-options-for-dependency-updates";
  optsLib = import ./options-lib.nix { inherit lib; };

  assignees.default = [];
  assignees.example = ["jaoooooo"];
  assignees.type = optsLib.listOfNonEmptyStr;
  assignees.description = ''
    Who will be assigned to pull request
  '';

  auto-rebase.default = null;
  auto-rebase.example = false;
  auto-rebase.type = lib.types.nullOr lib.types.bool;
  auto-rebase.description = ''
    Disable auto rebase (enabled by default)
    see [github documentations](${docs-url}#rebase-strategy)
  '';

  allows.all.default = false;
  allows.all.example = ["express"];
  allows.all.type = optsLib.boolOr optsLib.nonEmptyListOfNonEmptyStr;
  allows.all.description = ''
    All explicit and direct dependencies
  '';
  allows.direct.default = false;
  allows.direct.example = ["express"];
  allows.direct.type = optsLib.boolOr optsLib.nonEmptyListOfNonEmptyStr;
  allows.direct.description = ''
    All explicitly defined dependencies
  '';
  allows.indirect.default = false;
  allows.indirect.example = ["express"];
  allows.indirect.type = optsLib.boolOr optsLib.nonEmptyListOfNonEmptyStr;
  allows.indirect.description = ''
    Dependencies of dependencies
  '';
  allows.production.default = false;
  allows.production.example = ["express"];
  allows.production.type = optsLib.boolOr optsLib.nonEmptyListOfNonEmptyStr;
  allows.production.description = ''
    Dependencies for production
  '';
  allows.development.default = false;
  allows.development.example = ["express"];
  allows.development.type = optsLib.boolOr optsLib.nonEmptyListOfNonEmptyStr;
  allows.development.description = ''
    Dependencies for development
  '';
  allow.default = null;
  allow.example.production = true;
  allow.example.development = ["sphinix"];
  allow.type = lib.types.nullOr (optsLib.submoduleOf allows);
  allow.description = ''
    Customize which dependencies are updated,
    see [dependabot docs](${docs-url}#allow)
  '';

  commits.prefix.example = "RED-ALERT";
  commits.prefix.type = lib.types.nonEmptyStr;
  commits.prefix.description = "Prefix of commit message";
  commits.dev-prefix.default = null;
  commits.dev-prefix.example = "warn";
  commits.dev-prefix.type = optsLib.nullOrNonEmptyString;
  commits.dev-prefix.description = "Prefix of commit message for development dependencies";
  commits.scope.default = false;
  commits.scope.example = true;
  commits.scope.type = lib.types.bool;
  commits.scope.description = "If commit message should be contain scope";
  commit.default = null;
  commit.example.prefix = "RED-ALERT";
  commit.example.prefix-dev = "warn";
  commit.example.scope = true;
  commit.type = lib.types.nullOr (optsLib.submoduleOf commits);
  commit.description = ''
    Customize commit message prefix,
    see [dependabot docs](${docs-url}#commit-message)
  '';

  days = ["monday" "tuesday" "wednesday" "thursday" "friday" "saturday" "sunday"];
  day.default = null;
  day.example = "friday";
  day.type = lib.types.nullOr (lib.types.enum days);
  day.description = ''
    Day of week for weekly run (null is monday)
  '';

  labels.default = [];
  labels.example = ["depencencies"];
  labels.type = optsLib.listOfNonEmptyStr;
  labels.description = ''
    Labels to be added in pull request
    see [github documentations](${docs-url}#label)
  '';

  limit.default = null;
  limit.example = 5;
  limit.type = lib.types.nullOr lib.types.int;
  limit.description = ''
    Maximum open pull requests before next update
    see [github documentations](${docs-url}#open-pull-requests-limit)
  '';

  ignores.versions.default = [];
  ignores.versions.example = ["5.x.x" "^4.0.0"];
  ignores.versions.type = optsLib.listOfNonEmptyStr;
  ignores.versions.description = ''
    Versions to be ignored
  '';
  ignores.patch.default = false;
  ignores.patch.example = true;
  ignores.patch.type = lib.types.bool;
  ignores.patch.description = ''
    Ignore patch updates
  '';
  ignores.major.default = false;
  ignores.major.example = true;
  ignores.major.type = lib.types.bool;
  ignores.major.description = ''
    Ignore major updates
  '';
  ignores.minor.default = false;
  ignores.minor.example = true;
  ignores.minor.type = lib.types.bool;
  ignores.minor.description = ''
    Ignore minor updates
  '';
  ignore.default = {};
  ignore.example.sphinix.versions = ["4.x" "5.x"];
  ignore.example.django.patch = true;
  ignore.example.django.minor = true;
  ignore.example.django.major = true;
  ignore.example.express = true;
  ignore.type = lib.types.attrsOf (optsLib.boolOr (optsLib.submoduleOf ignores));
  ignore.description = ''
    Customize which dependencies are ignored,
    see [dependabot docs](#ignore)
  '';

  insecure-external-code-execution.default = null;
  insecure-external-code-execution.example = true;
  insecure-external-code-execution.type = lib.types.nullOr lib.types.bool;
  insecure-external-code-execution.description = ''
    Deny or allow external code execution,
    see [github documentations](${docs-url}#insecure-external-code-execution)
  '';

  intervals = ["daily" "weekly" "monthly"];
  interval.default = "weekly";
  interval.example = "monthly";
  interval.type = lib.types.enum intervals;
  interval.description = ''
    Periodicity of check: ${toString intervals}
  '';

  milestoneId.default = null;
  milestoneId.example = 4;
  milestoneId.type = lib.types.nullOr lib.types.int;
  milestoneId.description = ''
    Id of milestone associated with
    see [github documentations](${docs-url}#milestone)
  '';

  reviewers.default = [];
  reviewers.example = [ "your-user-name" "your-org/some-team" ];
  reviewers.type = optsLib.listOfNonEmptyStr;
  reviewers.description = ''
    List of developers to review
    see [github documentations](${docs-url}#reviewers)
  '';

  separator.example = "-";
  separator.default = null;
  separator.type = optsLib.nullOrNonEmptyString;
  separator.description = ''
    branch name separator
    see [github documentations](${docs-url}#pull-request-branch-nameseparator)
  '';

  target-branch.default = null;
  target-branch.example = "your-main-branch";
  target-branch.type = optsLib.nullOrNonEmptyString;
  target-branch.description = ''
    Branch to be target
    see [github documentations](${docs-url}#tarrget-branch)
  '';

  time.default = null;
  time.example = "16:25";
  time.type = lib.types.nullOr (lib.types.strMatching "[0-2][0-9]:[0-5][0-9]");
  time.description = ''
    Time of day to check for updates (format: hh:mm)
  '';

  timezone.default = null;
  timezone.example = "Asia/Tokyo";
  timezone.type = optsLib.nullOrNonEmptyString;
  timezone.description = ''
    Specify an time zone, time zone identifier is defined by
    [iana](https://www.iana.org/time-zones)
  '';

  vendor.default = false;
  vendor.example = true;
  vendor.type = lib.types.bool;
  vendor.description = ''
    tell Dependabot to vendor dependencies
    see [github documentations](${docs-url}#vendor)
  '';

  strategies = ["lockfile-only" "auto" "widen" "increase" "increase-if-necessary"];
  versioning-strategy.default = null;
  versioning-strategy.example = "auto";
  versioning-strategy.type = lib.types.nullOr (lib.types.enum strategies);
  versioning-strategy.description = ''
    Dependabot versioning strategy
    see [github documentations](${docs-url}#versioning-strategy)
  '';

  updates = {
    inherit
      auto-rebase
      allow
      assignees
      commit
      day
      ignore
      interval
      insecure-external-code-execution
      labels
      limit
      milestoneId
      separator
      reviewers
      target-branch
      time
      timezone
      vendor
      versioning-strategy;
  };
  gh-dependabot.default = {};
  gh-dependabot.example.npm = true;
  gh-dependabot.example.pip."/".interval = "weekly";
  gh-dependabot.type = lib.types.attrsOf (lib.types.attrsOf (optsLib.submoduleOf updates));
  gh-dependabot.description = ''
    Github dependabot configurations

    gh-dependabot.&lt;packager&gt;."&lt;directory&gt;".interval = "&lt;interval&gt;";

    See [github documentations](${docs-url}#configuration-options-for-updates)
    of package-ecosystem directory and interval
  '';
  registry.type.example = "maven-repository";
  registry.type.type = lib.types.nonEmptyStr;
  registry.type.description = ''
    type of registry
  '';
  registry.url.default = null;
  registry.url.example = "https://maven.pkg.github.com/your-org";
  registry.url.type = optsLib.nullOrNonEmptyString;
  registry.url.description = ''
    url of registry
  '';
  registry.username.default = null;
  registry.username.example = "your-repo-login";
  registry.username.type = optsLib.nullOrNonEmptyString;
  registry.username.description = ''
    username of registry
  '';
  registry.secret-name-pass.default = null;
  registry.secret-name-pass.example = "MY_ARTIFACTORY_PASSWORD";
  registry.secret-name-pass.type = optsLib.nullOrNonEmptyString;
  registry.secret-name-pass.description = ''
    gitub sercret name of password to access registry
  '';
  registry.secret-name-key.default = null;
  registry.secret-name-key.example = "MY_ARTIFACTORY_KEY";
  registry.secret-name-key.type = optsLib.nullOrNonEmptyString;
  registry.secret-name-key.description = ''
    gitub sercret name of key to access registry
  '';
  registry.secret-name-token.default = null;
  registry.secret-name-token.example = "MY_ARTIFACTORY_TOKEN";
  registry.secret-name-token.type = optsLib.nullOrNonEmptyString;
  registry.secret-name-token.description = ''
    gitub sercret name of token to access registry
  '';
  registry.replaces-base.default = false;
  registry.replaces-base.example = true;
  registry.replaces-base.type = lib.types.bool;
  registry.replaces-base.description = ''
    replaces base url
  '';
  registry.organization.default = null;
  registry.organization.example = "your-org";
  registry.organization.type = optsLib.nullOrNonEmptyString;
  registry.organization.description = ''
    organization name of login in registry
  '';
  gh-dependabot-registry.default = {};
  gh-dependabot-registry.example.maven-github.type = "maven-repository";
  gh-dependabot-registry.example.maven-github.url = "https://maven.pkg.github.com/your-org";
  gh-dependabot-registry.example.maven-github.username = "your-repo-login";
  gh-dependabot-registry.example.maven-github.secret-name = "MY_ARTIFACTORY_PASSWORD";
  gh-dependabot-registry.type = lib.types.attrsOf (optsLib.submoduleOf registry);
  gh-dependabot-registry.description = ''
    Disable auto rebase (enabled by default)
    see [github documentations](${docs-url}#registries)
  '';
in optsLib.optionsOf { inherit gh-dependabot gh-dependabot-registry; }
