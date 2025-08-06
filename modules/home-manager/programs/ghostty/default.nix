{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    package = pkgs.ghostty-bin;

    settings = {
      command = "${pkgs.fish}${pkgs.fish.shellPath} --login --interactive";
      font-family = "Berkeley Mono";
      font-size = 14;
      keybind = [
        "global:ctrl+alt+shift+cmd+q=toggle_quick_terminal"
      ];
      theme = "dark:flexoki-dark,light:flexoki-light";
    };
  };
}
