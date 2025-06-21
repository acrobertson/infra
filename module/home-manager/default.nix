{ pkgs, ... }:

{
  imports = [
    ./programs/_1password-shell-plugins
    ./programs/bat
    ./programs/direnv
    ./programs/fish
    ./programs/fzf
    ./programs/gh
    ./programs/git
    ./programs/karabiner
    ./programs/nushell
    ./programs/nvim
    ./programs/starship
    ./programs/taskwarrior
    ./programs/tmux
    ./programs/yazi
    ./programs/zoxide
    ./programs/zsh
  ];

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    colima
    docker
    docker-credential-helpers
    eza
    fastfetch
    fd
    ffmpeg
    htop
    jq
    nh
    nixfmt-rfc-style
    nodejs
    pandoc
    raycast
    ripgrep
    sd
    shortcat
    timewarrior
    tldr
    wget
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
