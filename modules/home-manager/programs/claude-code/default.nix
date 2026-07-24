{ ... }:

{
  programs.claude-code = {
    enable = true;

    settings = {
      terminalProgressBarEnabled = true;
      theme = "auto";
      tui = "fullscreen";
    };
  };
}
