{ config, lib, ...}:
let
  cfg = config.gh-form;
  hasAny = attrs: lib.mkIf (builtins.length (builtins.attrValues attrs) > 0);
  isEmpty = list: lib.mkIf (builtins.length list > 0) list;
  isEmpty' = list: lib.mkIf (builtins.length list > 0);
  ifNotNull = value: lib.mkIf (value != null) value;
  ifNotNull' = value: lib.mkIf (value != null);
  ifNull = value: default: if builtins.isNull value then default else value;
  toForm = name: form:
  let
    toDropdown = id: field: {
      inherit id;
      type = "dropdown";
      attributes.label = field.label;
      attributes.description = ifNotNull field.description;
      attributes.options = isEmpty field.options;
      attributes.multiple = lib.mkIf field.multiple true;
      validations = lib.mkIf field.required  { required = true; };
    };
    dropdowns = lib.mapAttrsToList toDropdown form.dropdown;
    toCheckbox = id: field: 
    let
      toOpt = label: { inherit label; };
      toRequiredOpt = label: { inherit label; required = true; };
      opts-non-required = map toOpt field.options;
      opts-required = map toRequiredOpt field.required-options;
      opts = opts-non-required ++ opts-required;
    in {
      inherit id;
      type = "checkboxes";
      attributes.label = field.label;
      attributes.description = ifNotNull field.description;
      attributes.options = isEmpty opts;
      validations = lib.mkIf field.required  { required = true; };
    };
    checkboxes = lib.mapAttrsToList toCheckbox form.checkboxes;
    toInput = id: field: {
      inherit id;
      type = "input";
      attributes.label = field.label;
      attributes.description = ifNotNull field.description;
      attributes.placeholder = ifNotNull field.placeholder;
      attributes.value = ifNotNull field.value;
      validations = lib.mkIf field.required  { required = true; };
    };
    inputs = lib.mapAttrsToList toInput form.input;
    toText = id: field: {
      inherit id;
      type = "textarea";
      attributes.label = field.label;
      attributes.description = ifNotNull field.description;
      attributes.placeholder = ifNotNull field.placeholder;
      attributes.value = ifNotNull field.value;
      attributes.render = ifNotNull field.render;
      validations = lib.mkIf field.required  { required = true; };
    };
    textareas = lib.mapAttrsToList toText form.text;
    toMarkdown = id: field: {
      type = "markdown";
      attributes.value = ifNotNull field.value;
    };
    markdown = lib.mapAttrsToList toMarkdown form.markdown;
    body = markdown ++ inputs ++ dropdowns ++ checkboxes ++ textareas;
  in {
    "/.github/ISSUE_TEMPLATE/${name}.yaml" = {
      name = ifNull form.name name;
      description = ifNotNull form.description;
      title = ifNotNull form.title;
      labels = isEmpty form.labels;
      assignees = isEmpty form.assignees;
      body = isEmpty body;
    };
  };
  yamls = lib.mapAttrsToList toForm cfg;
in
{
  imports = [ ./gh-form/gh-form-options.nix ];
  files.yaml = lib.foldAttrs lib.mergeAttrs {} yamls;
}
