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
}
