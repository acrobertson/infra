{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;

    package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings = {
      auto-update = "off";
      command = "${pkgs.fish}${pkgs.fish.shellPath} --login --interactive";
      font-family = "Berkeley Mono";
      font-size = 14;
      keybind = [
        "global:ctrl+alt+shift+cmd+q=toggle_quick_terminal"
      ];
      theme = "dark:Flexoki Dark,light:Flexoki Light";
    };
  };
}
