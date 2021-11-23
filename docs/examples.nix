''
  ## Examples
  
  The most basic example is used by this project to tag it self
  
  ```nix
  ${builtins.readFile ../templates/default/project.nix}
  ```
  
  It generate our .github/workflows/tag-me.yaml

  ```yaml
  ${builtins.readFile ../.github/workflows/tag-me.yaml}
  ```
  
  We should commit this yaml file because github can only read commited yaml files.

''
