''
  ## Examples


  #### Basic
  
  The most basic example is used by this project to tag it
  
  ```nix
  ${builtins.readFile ../templates/default/project.nix}
  ```

  <details>
  <summary>It generate our .github/workflows/tag-me.yaml (click to expand)</summary>
  <br>


  ```yaml
  ${builtins.readFile ../.github/workflows/tag-me.yaml}
  ```


  </details>

  
  We should commit this yaml file because github can only read commited yaml files.


  #### Complex


  This is a more complex example

  ```nix
  ${builtins.readFile ../examples/nodejs.nix}

  ```
''
