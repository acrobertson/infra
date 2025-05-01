{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "macos"
        "npm"
        "wp-cli"
      ];
      theme = "robbyrussell";
    };
    shellAliases = {
      # Changed your .gitignore _after_ you have added / committed some files?
      # run `gri` to untrack anything in your updated .gitignore
      gri = "git ls-files --ignored --exclude-standard | xargs -0 git rm -r";
      # Open all merge conflicts or currently changed files in VS Code
      # TODO: add `nvim` equivalent
      fix = "git diff --name-only | uniq | xargs code";
      # eza helpers
      l = "eza -lah --icons=auto";
      ll = "eza -lh --icons=auto";
      lt = "eza -T --icons=auto --git-ignore";
    };
    syntaxHighlighting = {
      enable = true;
    };
    initExtra = builtins.readFile ./zshrc;
  };
}
