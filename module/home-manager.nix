{pkgs, ...}: {
  # add home-manager user settings here
  home.packages = with pkgs; [eza fastfetch fd git htop jq neovim nixfmt-rfc-style pandoc ripgrep sd tldr wget];
  home.stateVersion = "23.11";

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enable = true;
    colors = {
      fg = "#878580";
      bg = "#100F0F";
      hl = "#CECDC3";
      "fg+" = "#878580";
      "bg+" = "#1C1B1A";
      "hl+" = "#CECDC3";
      border = "#AF3029";
      header = "#CECDC3";
      gutter = "#100F0F";
      spinner = "#24837B";
      info = "#24837B";
      separator = "#1C1B1A";
      pointer = "#AD8301";
      marker = "#AF3029";
      prompt = "#AD8301";
    };
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
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

  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    escapeTime = 0;
    historyLimit = 5000;
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.pain-control
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
    # NOTE: Disabling the sensible plugin due to shell issue
    # see https://github.com/nix-community/home-manager/issues/5952
    sensibleOnTop = false;
    extraConfig = builtins.readFile ../config/tmux/tmux.conf;
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
      # eza helpers
      l = "eza -lah --icons=auto";
      ll = "eza -lh --icons=auto";
      lt = "eza -T --icons=auto --git-ignore";
    };
    syntaxHighlighting = {
      enable = true;
    };
    initExtra = ''
      # Find project file with fzf and open it in nvim
      nf() {
        nvim $(fzf --preview "bat --color 'always' {}")
      }

      # Find tmux session with fzf and attach to it
      tf() {
        tmux attach -t "$(tmux ls -F '#{session_name}' | fzf)"
      }
    '';
  };
}
