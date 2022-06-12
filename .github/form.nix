{
  testing.description = "Testing GH Form";
  testing.title = "testing: ";
  testing.labels = ["testing"];
  testing.assignees = ["hugosenari"];
  testing.input.some-input.label = "some input";
  testing.input.some-input.description = "to test gh forms inputs";
  testing.input.some-input.value = "Valuable";
  testing.input.some-input.placeholder = "Hold!!!";
  testing.input.some-input.required = true;
  testing.checkboxes.some-check.label = "some check";
  testing.checkboxes.some-check.description = "test gh forms checkboxes";
  testing.checkboxes.some-check.required = true;
  testing.checkboxes.some-check.options = [ "some option"];
  testing.checkboxes.some-check.required-options = [ "some required option"];
  testing.dropdown.some-dropdown.label = "some dropdowns";
  testing.dropdown.some-dropdown.description = "test gh forms dropdown";
  testing.dropdown.some-dropdown.required = true;
  testing.dropdown.some-dropdown.multiple = true;
  testing.dropdown.some-dropdown.options = [ "some other option"];
  testing.text.some-text.label = "some text";
  testing.text.some-text.description = "to test gh forms texts";
  testing.text.some-text.placeholder = "some bash!!!";
  testing.text.some-text.required = true;
  testing.text.some-text.render = "bash";
  testing.text.some-text.value = ''
    echo "Hello World"
  '';
  testing.markdown.some-markdown.value = ''
    # Im a markdown

    I will will be displayed at form page
    I'm not intented to be filled by user, only displayed to user
  '';
}
