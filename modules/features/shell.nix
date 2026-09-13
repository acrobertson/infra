{ ... }:

{
  den.aspects.shell = {
    homeManager =
      { pkgs, ... }:
      {
        programs.bat = {
          enable = true;
          config = {
            theme = "base16";
          };
        };

        programs.carapace.enable = true;

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

            nf = {
              description = "Fuzzy find file and open with nvim";
              body =
                # fish
                ''
                  nvim $(fzf --preview "bat --color 'always' {}")
                '';
            };

            tf = {
              description = "Fuzzy find tmux session and attach to it";
              body =
                # fish
                ''
                  tmux attach -t "$(tmux ls -F '#{session_name}' | fzf)"
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
            ga = "git add";
            gap = "git add -p";
            gb = "git branch";
            gc = "git commit";
            gl = "git log";
            glo = "git log --oneline";
            glog = "git log --oneline --graph";
            gpr = "git pull --rebase";
            gP = "git push";
            gPF = "git push --force-with-lease";
            grb = "git rebase";
            grbi = "git rebase --interactive";
            grs = "git restore";
            gst = "git status";
            gsw = "git switch";

            # Eza
            l = "eza -lah --icons=auto";
            ll = "eza -lh --icons=auto";
            lt = "eza -T --icons=auto --git-ignore";
          };

          shellAliases = {
            sail = "sh $([ -f sail ] && echo sail || echo vendor/bin/sail)";
          };
        };

        programs.fzf = {
          enable = true;
          defaultCommand = "rg --files --hidden --glob '!.git/*'";
          defaultOptions = [ "--color=16" ];
        };

        programs.nushell.enable = true;

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

        programs.yazi = {
          enable = true;
          shellWrapperName = "y";
          settings = {
            mgr = {
              show_hidden = true;
            };
          };
        };

        programs.zoxide.enable = true;

        home.packages = with pkgs; [
          btop
          curl
          eza
          fastfetch
          fd
          ffmpeg
          jq
          ripgrep
          rsync
          sd
          tldr
          wget
        ];

        home.sessionVariables = {
          EDITOR = "nvim";
          VISUAL = "nvim";
          CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense,carapace";
        };
      };

    darwin = {
      programs.fish.enable = true;
      programs.zsh.enable = true;
      homebrew.brews = [
        "asimov"
        "mole"
      ];
    };

    nixos.programs.fish.enable = true;
  };
}
