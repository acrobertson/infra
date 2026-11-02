{ den, inputs, ... }:

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
          programs.claude-code = {
            enable = true;

            package = pkgs.unstable.claude-code;

            plugins = [
              ponytailPlugin
              inputs.basecamp-cli
            ];

            hooks = {
              op-gh-credentials =
                # sh
                ''
                  #!/usr/bin/env bash
                  # PreToolUse hook: wrap `gh` Bash commands with `op run` to inject
                  # GH_TOKEN from 1Password. Override the secret ref with OP_GH_TOKEN_REF.
                  set -uo pipefail

                  command -v jq >/dev/null || exit 0
                  command -v op >/dev/null || exit 0

                  input=$(cat)
                  read -r tool_name cmd < <(
                    jq -r '[.tool_name, (.tool_input.command // "")] | @tsv' <<<"$input"
                  ) || exit 0

                  [[ $tool_name == Bash ]] || exit 0

                  # Rewrite only bare `gh` invocations that aren't already op-wrapped.
                  gh_re='(^|[[:space:];&|(])gh([[:space:]]|$)'
                  op_re='(^|[[:space:];&|(])op[[:space:]]+(run|plugin)'
                  [[ $cmd =~ $gh_re && ! $cmd =~ $op_re ]] || exit 0

                  ref=''${OP_GH_TOKEN_REF:-op://Private/naklywt4nwbp672uabfwmgwnte/token}
                  new_cmd=$(printf 'GH_TOKEN=%q op run -- bash -c %q' "$ref" "$cmd")

                  jq -nc --arg cmd "$new_cmd" '{
                    hookSpecificOutput: {
                      hookEventName: "PreToolUse",
                      permissionDecision: "allow",
                      updatedInput: { command: $cmd }
                    }
                  }'
                '';
            };

            settings = {
              editorMode = "vim";
              effortLevel = "medium";
              hooks = {
                PreToolUse = [
                  {
                    matcher = "Bash";
                    hooks = [
                      {
                        type = "command";
                        command = "~/.claude/hooks/op-gh-credentials";
                        timeout = 5;
                      }
                    ];
                  }
                ];
              };
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
