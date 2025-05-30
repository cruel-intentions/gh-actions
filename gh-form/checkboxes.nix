{ lib }:
let
  field-docs-url = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema";
  optsLib = import ../options-lib.nix { inherit lib; };
in {
  label.example = "Are you sure?";
  label.type = lib.types.nonEmptyStr;
  label.description = ''
    Label of checkboxes input

    See [github documentations](${field-docs-url}#checkboxes)
  '';
  description.default = null;
  description.example = "Confirm this checking";
  description.type = optsLib.nullOrNonEmptyString;
  description.description = ''
    Description of checkboxes input

    See [github documentations](${field-docs-url}#checkboxes)
  '';
  options.default = [];
  options.example = ["spam me"];
  options.type = optsLib.listOfNonEmptyStr;
  options.description = ''
    Values that can be checked

    See [github documentations](${field-docs-url}#checkboxes)
  '';
  required-options.default = [];
  required-options.example = ["I'm sure"];
  required-options.type = optsLib.listOfNonEmptyStr;
  required-options.description = ''
    Values that can be checked that need to be checked

    See [github documentations](${field-docs-url}#checkboxes)
  '';
  required.default = false;
  required.example = true;
  required.type = lib.types.bool;
  required.description = ''
    If this text input is required

    See [github documentations](${field-docs-url}#dropdown)
  '';

}
