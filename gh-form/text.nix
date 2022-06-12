{ lib }:
let
  field-docs-url = "https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/syntax-for-githubs-form-schema#about-githubs-form-schema";
  optsLib = import ../options-lib.nix { inherit lib; };
in {
  label.example = "Greeting message";
  label.type = lib.types.nonEmptyStr;
  label.description = ''
    Label of text input

    See [github documentations](${field-docs-url}#textarea)
  '';
  description.default = null;
  description.example = "Greeting message";
  description.type = optsLib.nullOrNonEmptyString;
  description.description = ''
    Description of text input

    See [github documentations](${field-docs-url}#textarea)
  '';
  placeholder.default = null;
  placeholder.example = "Insert your long text here";
  placeholder.type = optsLib.nullOrNonEmptyString;
  placeholder.description = ''
    Placeholder for text input

    See [github documentations](${field-docs-url}#textarea)
  '';
  value.default = null;
  value.example = "Happy new year!!";
  value.type = optsLib.nullOrNonEmptyString;
  value.description = ''
    Default value for text input

    See [github documentations](${field-docs-url}#textarea)
  '';
  required.default = false;
  required.example = true;
  required.type = lib.types.bool;
  required.description = ''
    If this text input is required

    See [github documentations](${field-docs-url}#textarea)
  '';
  render.default = null;
  render.example = "bash";
  render.type = optsLib.nullOrNonEmptyString;
  render.description = ''
    If this should be rendered as code block of specified type

    See [github documentations](${field-docs-url}#textarea)
  '';
}
