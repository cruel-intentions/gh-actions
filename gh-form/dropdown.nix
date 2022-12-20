{ lib }:
let
  field-docs-url = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema";
  optsLib = import ../options-lib.nix { inherit lib; };
in {
  label.example = "Greeting type";
  label.type = lib.types.nonEmptyStr;
  label.description = ''
    Label of dropdown input

    See [github documentations](${field-docs-url}#dropdown)
  '';
  description.default = null;
  description.example = "Type of greeting message";
  description.type = optsLib.nullOrNonEmptyString;
  description.description = ''
    Description of dropdown input

    See [github documentations](${field-docs-url}#dropdown)
  '';
  multiple.default = false;
  multiple.example = true;
  multiple.type = lib.types.bool;
  multiple.description = ''
    If more than one could be selected

    See [github documentations](${field-docs-url}#dropdown)
  '';
  options.example = ["birthday" "new-year"];
  options.type = optsLib.listOfNonEmptyStr;
  options.description = ''
    Values that can be selected

    See [github documentations](${field-docs-url}#dropdown)
  '';
  required.default = false;
  required.example = true;
  required.type = lib.types.bool;
  required.description = ''
    If this dropdown input is required

    See [github documentations](${field-docs-url}#dropdown)
  '';
}
