{ den, inputs, ... }:

{
  den.aspects.development = {
    includes = [ (den.batteries.unfree [ "claude-code" ]) ];

    homeManager =
      { pkgs, ... }:
      let
        mattPocockSkillsPlugin = pkgs.fetchFromGitHub {
          owner = "mattpocock";
          repo = "skills";
          tag = "v1.1.0";
          hash = "sha256-XqF709Y9GMKINzZITlbCTyatG9AxRZh0qn2vcv1Z8yo=";
        };
      in
      {
        imports = [ inputs.neovim-config.homeModule ];

        programs.claude-code = {
          enable = true;

          package = pkgs.unstable.claude-code;

          plugins = [
            mattPocockSkillsPlugin
          ];

          settings = {
            autoCompactEnabled = false;
            editorMode = "vim";
            effortLevel = "medium";
            model = "claude-opus-4-8";
            permissions = {
              allow = [
                "Read(./.env.example)"
              ];
              deny = [
                "Read(./.env)"
                "Read(./.env.*)"
                "Read(./secrets/**)"
                "Read(./config/credentials.json)"
                "Read(./build)"
                "Read(./dist)"
              ];
              disableBypassPermissionsMode = "disable";
            };
            spinnerTipsEnabled = false;
            spinnerVerbs = {
              mode = "replace";
              verbs = [ "Trying" ];
            };
            statusLine = {
              command = "ccusage statusline --context-low-threshold 20 --context-medium-threshold 50";
              padding = 0;
              type = "command";
            };
            terminalProgressBarEnabled = true;
            theme = "auto";
            tui = "fullscreen";
          };
        };

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        nvim = {
          enable = true;
          packageNames = [
            "nvim"
            "nvim-test"
          ];
        };

        programs.opencode = {
          enable = true;
          extraPackages = with pkgs; [
            nixd
            nixfmt
            phpactor
            rust-analyzer
            rustfmt
            shfmt
            uv
          ];
          package = pkgs.unstable.opencode;
          settings = {
            formatter = true;
            # lsp = {
            #   "intelephense" = {
            #     command = [ "intelephense" ];
            #     disbled = true;
            #   };
            #   phpactor = {
            #     command = [
            #       "phpactor"
            #       "language-server"
            #     ];
            #     extensions = [ ".php" ];
            #   };
            # };
            permission = {
              "*" = "ask";
              bash = {
                "*" = "ask";
                "git status" = "allow";
                "grep *" = "allow";
                "rm *" = "deny";
              };
              edit = "ask";
              read = {
                "*" = "allow";
                "*.env" = "deny";
                "*.env.*" = "deny";
                "*.env.example" = "allow";
              };
              external_directory = "deny";
            };
            share = "disabled";
          };
        };

        programs.taskwarrior = {
          enable = true;
          package = pkgs.taskwarrior3;
          config = {
            hooks.location = "~/.config/task/hooks";
          };
        };

        home.packages = with pkgs; [
          nixfmt
          nodejs
          pandoc
          skills
          timewarrior
          unstable.ccusage
        ];

        xdg.configFile."task/hooks" = {
          recursive = true;
          source = ./hooks;
          executable = true;
        };
      };
  };
}
