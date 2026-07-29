{ pkgs, ... }:

{
  programs.claude-code = {
    enable = true;

    package = pkgs.unstable.claude-code;

    settings = {
      terminalProgressBarEnabled = true;
      theme = "auto";
      tui = "fullscreen";
    };
  };
}
