''
  ## Examples


  #### Basic
  
  The most basic example is used by this project to tag it
  
  ```nix
  # project.nix
  ${builtins.readFile ../templates/default/project.nix}
  ```

  <details>
  <summary>It generate our .github/workflows/tag-me.yaml (click to expand)</summary>
  <br>


  ```yaml
  # .github/workflows/tag-me.yaml
  ${builtins.readFile ../.github/workflows/tag-me.yaml}
  ```


  </details>

  
  We should commit this yaml file because github can only read commited yaml files.


  #### Complex


  This is a more complex example

  ```nix
  # examples/nodejs.nix
  ${builtins.readFile ../examples/nodejs.nix}

  ```
''
