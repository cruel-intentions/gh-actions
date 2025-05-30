let 
  useless = [
    "Would you be willing to pay me a coffe for it?"
    "What about pizzas?"
    "Is your spiritual animal offended with previous question?"
    "Is your spiritual animal already working on it in your head?"
    "Are you wondering why I'm asking these questions?"
    "Are you asking yourself if you should give up of opening it?"
    "Isn't your eye bleeding yet?"
    "Should I add more questions?"
  ];
in
{
  gh-form.bug.description = "Report bugs";
  gh-form.bug.title       = "bug: ";
  gh-form.bug.labels      = ["bug"];
  gh-form.bug.text.actual-behavior.label         = "Actual Behavior";
  gh-form.bug.text.actual-behavior.description   = "What is happening";
  gh-form.bug.text.actual-behavior.required      = true;
  gh-form.bug.text.expected-behavior.label       = "Expected Behavior";
  gh-form.bug.text.expected-behavior.description = "What should happen";
  gh-form.bug.text.expected-behavior.required    = true;
  gh-form.bug.text.reproduce.label               = "How to reproduce";
  gh-form.bug.text.reproduce.description         = "Describe how to reproduce";
  gh-form.bug.checkboxes.more-info.label         = "Please awnser following questions";
  gh-form.bug.checkboxes.more-info.options       = [
    "Is this bug critical for your workflow?"
    "Would you willing to open a PR?"
  ] ++ useless;
  gh-form.feat.description = "Feature Request";
  gh-form.feat.title       = "feat: ";
  gh-form.feat.labels      = ["feat"];
  gh-form.feat.text.problem.label           = "What problem this feature solve";
  gh-form.feat.text.description.label       = "Describe your proposed solution";
  gh-form.feat.text.description.required    = true;
  gh-form.feat.text.some-alt.label          = "How you are overcoming this problem";
  gh-form.feat.checkboxes.more-info.label   = "Please anwser following questions";
  gh-form.feat.checkboxes.more-info.options = [
    "Would you willing to open a PR?"
  ] ++ useless;
}
