{ lib, ... }:
let
  docs-url       = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-issue-forms";
  field-docs-url = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema";
  optsLib        = import ../options-lib.nix { inherit lib; };
  name.default            = null;
  name.example            = "Bug report";
  name.type               = optsLib.nullOrNonEmptyString;
  name.description        = ''
    A name for the issue form template

    see [github documentations](${docs-url}#top-level-syntax)
  '';
  description.example     = "File a bug report";
  description.type        = lib.types.nonEmptyStr;
  description.description = ''
    A description for the issue form template

    see [github documentations](${docs-url}#top-level-syntax)
  '';
  title.default           = null;
  title.example           = "[Bug]: ";
  title.type              = optsLib.nullOrNonEmptyString;
  title.description       = ''
    Default title of issue

    see [github documentations](${docs-url}#top-level-syntax)
  '';
  labels.default          = [];
  labels.example          = ["bug" "critical"];
  labels.type             = optsLib.listOfNonEmptyStr;
  labels.description      = ''
    Labels to this kind of issue

    see [github documentations](${docs-url}#top-level-syntax)
  '';
  assignees.default       = [];
  assignees.example       = ["hugosenari"];
  assignees.type          = optsLib.listOfNonEmptyStr;
  assignees.description   = ''
    List of assignees to this kind of issue

    see [github documentations](${docs-url}#top-level-syntax)
  '';
  inputs = import ./input.nix { inherit lib; };
  input.default = {};
  input.type    = lib.types.attrsOf (optsLib.submoduleOf inputs);
  input.example.frequency.description = "How many times it happens";
  input.example.frequency.label       = "Frequency";
  input.description = ''
    Github forms body input fields

    gh-forms.&lt;file-name&gt;.input.&lt;field-id&gt;.label = "&lt;label&gt;";
    gh-forms.&lt;file-name&gt;.input.&lt;field-id&gt;.description = "&lt;description&gt;";

    See [github documentations](${field-docs-url}#input)
  '';
  texts = import ./text.nix { inherit lib; };
  text.default = {};
  text.type    = lib.types.attrsOf (optsLib.submoduleOf texts);
  text.example.greeting.description = "Insert your greeting message";
  text.example.greeting.label       = "Greeting message";
  text.description = ''
    Github forms body text fields

    gh-forms.&lt;file-name&gt;.text.&lt;field-id&gt;.label = "&lt;label&gt;";
    gh-forms.&lt;file-name&gt;.text.&lt;field-id&gt;.description = "&lt;description&gt;";

    See [github documentations](${field-docs-url}#textarea)
  '';
  markdowns = import ./markdown.nix { inherit lib; };
  markdown.default = {};
  markdown.type    = lib.types.attrsOf (optsLib.submoduleOf markdowns);
  markdown.example.some.required = true;
  markdown.example.some.value    = "Some markdown text";
  markdown.description = ''
    Github forms body markdown fields

    gh-forms.&lt;file-name&gt;.markdown.&lt;field-id&gt;.required = true;
    gh-forms.&lt;file-name&gt;.markdown.&lt;field-id&gt;.value = "&lt;value&gt;";

    See [github documentations](${field-docs-url}#input)
  '';
  drops = import ./dropdown.nix { inherit lib; };
  dropdown.default = {};
  dropdown.type    = lib.types.attrsOf (optsLib.submoduleOf drops);
  dropdown.example.greeting-type.description = "Types of greeting message";
  dropdown.example.greeting-type.label       = "Greeting type";
  dropdown.description = ''
    Github forms body dropdown fields

    gh-forms.&lt;file-name&gt;.dropdown.&lt;field-id&gt;.label = "&lt;label&gt;";
    gh-forms.&lt;file-name&gt;.dropdown.&lt;field-id&gt;.description = "&lt;description&gt;";

    See [github documentations](${field-docs-url}#dropdown)
  '';
  checks = import ./checkboxes.nix { inherit lib; };
  checkboxes.default = {};
  checkboxes.type    = lib.types.attrsOf (optsLib.submoduleOf checks);
  checkboxes.example.agreement.description = "Check to confirm";
  checkboxes.example.agreement.label       = "Are you sure?";
  checkboxes.description = ''
    Github forms body dropdown fields

    gh-forms.&lt;file-name&gt;.checkboxes.&lt;field-id&gt;.label = "&lt;label&gt;";
    gh-forms.&lt;file-name&gt;.checkboxes.&lt;field-id&gt;.description = "&lt;description&gt;";

    See [github documentations](${field-docs-url}#checkboxes)
  '';
  gh-forms = {
    inherit name description title labels assignees;
    inherit input markdown text dropdown checkboxes;
  };
  gh-form.default     = {};
  gh-form.example     = import ../.github/form.nix;
  gh-form.type        = lib.types.attrsOf (optsLib.submoduleOf gh-forms);
  gh-form.description = ''
    Disable auto rebase (enabled by default)
    see [github documentations](${docs-url}#registries)
  '';
in optsLib.optionsOf { inherit gh-form; }
