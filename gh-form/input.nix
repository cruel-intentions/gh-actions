{ lib }:
let
  field-docs-url = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema";
  optsLib = import ../options-lib.nix { inherit lib; };
in
{
  label.example = "Frequency";
  label.type = lib.types.nonEmptyStr;
  label.description = ''
    Label of input

    See [github documentations](${field-docs-url}#input)
  '';
  description.default = null;
  description.example = "How many times it happens";
  description.type = optsLib.nullOrNonEmptyString;
  description.description = ''
    Description of input

    See [github documentations](${field-docs-url}#input)
  '';
  placeholder.default = null;
  placeholder.example = "every 5 days";
  placeholder.type = optsLib.nullOrNonEmptyString;
  placeholder.description = ''
    Placeholder for input

    See [github documentations](${field-docs-url}#input)
  '';
  value.default = null;
  value.example = "11 times in a week";
  value.type = optsLib.nullOrNonEmptyString;
  value.description = ''
    Default value for input

    See [github documentations](${field-docs-url}#input)
  '';
  required.default = false;
  required.example = true;
  required.type = lib.types.bool;
  required.description = ''
    If this input is required

    See [github documentations](${field-docs-url}#input)
  '';
}
