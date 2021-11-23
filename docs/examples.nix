''
  ## Examples
  
  The most basic example is used by this project to tag it self
  
  ```nix
  ${builtins.readFile ../templates/default/project.nix}
  ```

  <details>
  <summary>It generate our .github/workflows/tag-me.yaml</summary>
  <br>
  ```yaml
  ${builtins.readFile ../.github/workflows/tag-me.yaml}
  ```
  </details>

  
  We should commit this yaml file because github can only read commited yaml files.
''
