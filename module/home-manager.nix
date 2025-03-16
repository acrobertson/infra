{ inputs }:
{ pkgs, ... }:
{
  # add home-manager user settings here
  home.packages = with pkgs; [
    colima
    docker
    eza
    fastfetch
    fd
    htop
    jq
    nixfmt-rfc-style
    pandoc
    ripgrep
    sd
    shortcat
    tldr
    wget
  ];
  home.stateVersion = "23.11";

  imports = [
    inputs._1password-shell-plugins.hmModules.default
    inputs.neovim-config.homeModule
  ];

  nvim = {
    enable = true;
    packageNames = [
      "nvim" # default build
      "nvim-test" # loads straight from lua, for testing config tweaks
    ];
  };

  programs._1password-shell-plugins = {
    enable = true;
    plugins = with pkgs; [ gh ];
  };

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

  programs.fish = {
    enable = true;
    functions = {
      multicd = {
        description = "Transform `..` into `cd ../`, `...` into `cd ../../`, etc.";
        body =
          # fish
          ''
            echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
          '';
      };
    };
    shellAbbrs = {
      # cd
      dotdot = {
        regex = ''^\.\.+$'';
        function = "multicd";
      };
      # Git
      g = "git";
      gco = "git checkout";
      gl = "git pull";
      glr = "git pull --rebase";
      gp = "git push";
      gpf = "git push --force-with-lease";
      grb = "git rebase";
      grs = "git restore";
      gst = "git status";
      gsw = "git switch";
      # Eza
      l = "eza -lah --icons=auto";
      ll = "eza -lh --icons=auto";
      lt = "eza -T --icons=auto --git-ignore";
    };
  };

  programs.fzf = {
    enable = true;
    # Flexoki theme
    # see https://github.com/kepano/flexoki/tree/main/fzf
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

  programs.git = {
    enable = true;
    signing = {
      format = "ssh";
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfvNCCpiGWrLTVyUAXulTNPIF7Rda3Y5iynk1dSxfBa";
      signByDefault = true;
      # TODO: integrate with GUI from nix?
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };
    userEmail = "alec.robertson08@gmail.com";
    userName = "Alec Robertson";
    extraConfig = {
      add = {
        interactive.useBuiltin = false;
      };
      branch = {
        sort = "-committerdate";
      };
      column = {
        ui = "auto";
      };
      commit = {
        verbose = true;
      };
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      github = {
        user = "acrobertson";
      };
      help = {
        autocorrect = "prompt";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictstyle = "zdiff3";
      };
      pull = {
        rebase = false;
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      tag = {
        sort = "version:refname";
      };
    };
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
      };
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
      nix_shell = {
        format = "[$symbol$state( \($name\))]($style) ";
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
      tmuxPlugins.vim-tmux-navigator
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

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
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
      plugins = [
        "git"
        "macos"
        "npm"
        "wp-cli"
      ];
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
    initExtra = builtins.readFile ../config/zsh/zshrc;
  };
}
