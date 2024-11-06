{pkgs, ...}: {
  # add home-manager user settings here
  home.packages = with pkgs; [fastfetch fd git htop jq neovim pandoc ripgrep sd tldr wget];
  home.stateVersion = "23.11";

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.nushell = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      character = {
        success_symbol = "[⚰](bold green)";
        error_symbol = "[⚰](bold red)";
        vimcmd_symbol = "[⚰](bold greend)";
      };
      aws = {
        disabled = true;
      };
      deno = {
        format = "[$symbol($version )]($style)";
      };
      docker_context = {
        format = "[$symbol$context]($style) ";
      };
      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };
      nodejs = {
        format = "[$symbol($version )]($style)";
      };
      package = {
        disabled = true;
      };
      php = {
        format = "[$symbol($version )]($style)";
        symbol = " ";
      };
      rust = {
        format = "[$symbol($version )]($style)";
      };
    };
  };

  programs.zoxide = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "macos" "npm" "wp-cli"];
      theme = "robbyrussell";
    };
    sessionVariables = {
      EDITOR = "vi -e";
      VISUAL = "nvim";
    };
    shellAliases = {
      # Changed your .gitignore _after_ you have added / committed some files?
      # run `gri` to untrack anything in your updated .gitignore
      gri = "git ls-files --ignored --exclude-standard | xargs -0 git rm -r";
      # Open all merge conflicts or currently changed files in VS Code
      # TODO: add `nvim` equivalent
      fix = "git diff --name-only | uniq | xargs code";
    };
    syntaxHighlighting = {
      enable = true;
    };
  };
}
