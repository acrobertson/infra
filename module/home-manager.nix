{pkgs, ...}: {
  # add home-manager user settings here
  home.packages = with pkgs; [fastfetch fd git htop jq neovim ripgrep sd tldr wget];
  home.stateVersion = "23.11";

  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };

  programs.zoxide = {
    enable = true;
  };
}
