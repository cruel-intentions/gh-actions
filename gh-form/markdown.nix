{ lib }:
let
  field-docs-url = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema";
  optsLib = import ../options-lib.nix { inherit lib; };
in
{
  value.default = "";
  value.example = "11 times in a week";
  value.type = optsLib.nullOrNonEmptyString;
  value.description = ''
    Default value for markdown input

    See [github documentations](${field-docs-url}#markdown)
  '';
}
