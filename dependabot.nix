{ config, lib, ... }:
let
  cfg = config.gh-dependabot;
  registries =  config.gh-dependabot-registry;
  hasAny = attrs: lib.mkIf (builtins.length (builtins.attrValues attrs) > 0);
  ifNotNull = value: lib.mkIf (value != null) value;
  ifNotNull' = value: lib.mkIf (value != null);
  ifNotEmpty = values: lib.mkIf ((builtins.length values) > 0) values;
  allow = dependency-type: value: 
    if value == true then [ { inherit dependency-type; } ]
    else if value == false then []
    else map (dependency-name: { inherit dependency-name dependency-type; }) value;
  ignoreSemver = type: value: if value == true then ["version-update:semver-${type}"] else [];
  ignore = dependency-type: value:
    if value == true then { inherit dependency-type; }
    else {
      inherit dependency-type;
      versions = ifNotEmpty value.versions;
      update-types = lib.flatten (builtins.mapAttrsToList ignoreSemver value);
    };
  commitMessage = value: {
    prefix = value.prefix;
    prefix-development = ifNotNull value.dev-prefix;
    include = lib.mkIf value.scope "scope";
  };
  externalExecution = value: ifNotNull' value (
    if value == true then "allow" else "deny"
  );
  rebaseStrategy = value: ifNotNull' value (
    if value == true then "auto" else "disabled"
  );
  toUpdate = package-ecosystem: directory: value: {
    inherit package-ecosystem directory;
    schedule.interval = value.interval;
    schedule.day = ifNotNull value.day;
    schedule.time = ifNotNull value.time;
    schedule.timezone = ifNotNull value.timezone;
    allow = ifNotNull' value.allow (lib.flatten (lib.mapAttrsToList allow value.allow));
    ignore = hasAny value.ignore (lib.mapAttrsToList ignore value.ignore);
    assignees = ifNotEmpty value.assignees;
    commit-message = ifNotNull' value.commit (commitMessage value.commit);
    insecure-external-code-execution = externalExecution value.insecure-external-code-execution;
    labels = ifNotEmpty value.labels;
    milestone = ifNotNull value.milestoneId;
    open-pull-requests-limit = ifNotNull value.limit;
    pull-request-branch-name.separator = ifNotNull value.separator;
    rebase-strategy = rebaseStrategy value.auto-rebase;
    reviewers = ifNotEmpty value.reviewers;
    target-branch = ifNotNull value.target-branch;
    vendor = lib.mkIf value.vendor value.vendor;
    versioning-strategy = ifNotNull value.versioning-strategy;
  };
  convertSecret = value: ifNotNull' value "${"$"}{{secrets.${value}}}";
  registry = name: value: {
    organization = ifNotNull value.organization;
    type = ifNotNull value.type;
    url = ifNotNull value.url;
    username = ifNotNull value.username;
    key = convertSecret value.secret-name-key;
    password = convertSecret value.secret-name-pass;
    token = convertSecret value.secret-name-token;
  };
  dependabot.version = 2;
  dependabot.registries = hasAny registries (
    builtins.mapAttrs registry registries
  );
  dependabot.updates = lib.flatten (
    lib.mapAttrsToList (
      package-ecosystem: paths: lib.mapAttrsToList (toUpdate package-ecosystem) paths
    ) cfg
  );
in
{
  imports = [ ./dependabot-options.nix ];
  config.files.yaml = hasAny cfg {
    "/.github/dependabot.yml" = dependabot;
  };
}
