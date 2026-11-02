{ den, inputs, ... }:

let
  # Agents' Bash tools don't get the `op plugin` gh wrapper, so unlock a
  # GH_TOKEN once per session instead of once per call. WSL has no Linux `op`;
  # Windows' op.exe unlocks through Windows Hello instead.
  withGhToken = cmd: ref: {
    description = "Run ${cmd} with GH_TOKEN from 1Password";
    wraps = cmd;
    body =
      # fish
      ''
        set -l op op
        type -q op.exe; and set op op.exe
        set -lx GH_TOKEN ($op read "${ref}"); or return
        command ${cmd} $argv
      '';
  };
in
{
  den.aspects.development = {
    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs.neovim-config.homeModule ];

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

        # Personal repos only, so personal harnesses can't reach work orgs.
        programs.fish.functions.opencode = withGhToken "opencode" "op://Agents/Coding Agents GH token/token";

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

        home.packages = with pkgs; [
          agent-browser
          nixfmt
          nodejs
          pandoc
          skills
        ];
      };

    # claude-code and the ccusage statusline are only used on pequod
    provides.pequod = {
      includes = [ (den.batteries.unfree [ "claude-code" ]) ];

      homeManager =
        { pkgs, ... }:
        let
          ponytailPlugin = pkgs.fetchFromGitHub {
            owner = "DietrichGebert";
            repo = "ponytail";
            tag = "v4.9.0";
            hash = "sha256-8cYggVltBAlZ/Zj4pl1bOu7mQdZFXCmDGW4RSpvRA+w=";
          };
        in
        {
          # Classic token: Claude is used for work across both company orgs.
          programs.fish.functions.claude = withGhToken "claude" "op://Claude/Claude GitHub Personal Access Token/token";

          programs.claude-code = {
            enable = true;

            package = pkgs.unstable.claude-code;

            plugins = [
              ponytailPlugin
              inputs.basecamp-cli
            ];

            settings = {
              editorMode = "vim";
              effortLevel = "medium";
              model = "claude-opus-5-5";
              outputStyle = "Concise";
              permissions = {
                allow = [
                  "Read(./.env.example)"
                  "Read(node_modules/next/dist/docs/**)"
                ];
                deny = [
                  # Deny unneeded builtin rules
                  "EnterPlanMode"
                  "ExitPlanMode"
                  "DesignSync"
                  "NotebookEdit"
                  "SendMessage"
                  "PushNotification"
                  "RemoteTrigger"
                  "ReportFindings"
                  "ScheduleWakeup"
                  "AskUserQuestion"
                  "CronCreate"
                  "CronDelete"
                  "CronList"
                  # Protect secrets
                  "Read(./.env)"
                  "Read(./.env.*)"
                  "Read(./secrets/**)"
                  "Read(./config/credentials.json)"
                  "Read(./build)"
                  "Read(./dist)"
                ];
                defaultMode = "auto";
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

          home.packages = [ pkgs.unstable.ccusage ];
        };
    };
  };
}
