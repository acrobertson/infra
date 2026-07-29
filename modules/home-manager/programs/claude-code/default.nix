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
      terminalProgressBarEnabled = true;
      theme = "auto";
      tui = "fullscreen";
    };
  };
}
