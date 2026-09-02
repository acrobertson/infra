{ ... }:

{
  den.aspects.git = {
    homeManager =
      {
        lib,
        userConfig,
        pkgs,
        ...
      }:
      {
        programs.delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            navigate = true;
            line-numbers = true;
          };
        };

        programs.gh = {
          enable = true;
          # On macOS gh comes wrapped by the 1Password GUI install; only
          # configure it here. Elsewhere install a real gh.
          # see https://github.com/nix-community/home-manager/issues/4763
          package = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs.gh;
          settings = {
            git_protocol = "ssh";
          };
        };

        programs.git = {
          enable = true;

          lfs = {
            enable = true;
          };

          signing = {
            format = "ssh";
            key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIfvNCCpiGWrLTVyUAXulTNPIF7Rda3Y5iynk1dSxfBa";
            signByDefault = true;
            # The 1Password GUI signer only exists on macOS; Linux hosts
            # provide their own signer (see provides.hodor below).
            signer = lib.mkIf pkgs.stdenv.isDarwin "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
          };

          settings = {
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
            user = {
              email = userConfig.email;
              name = userConfig.fullName;
            };
          };
        };
      };

    # Keep WSL-only Git transport and signing scoped to the Hodor-bound home.
    # Signer path per 1Password's WSL docs (MSIX apps live under WindowsApps):
    # https://www.1password.dev/ssh/integrations/wsl
    provides.hodor.homeManager =
      { ... }:
      {
        programs.git = {
          settings.core.sshCommand = "ssh.exe";
          signing.signer = "/mnt/c/Users/superbluesbros/AppData/Local/Microsoft/WindowsApps/op-ssh-sign-wsl.exe";
        };
      };
  };
}
