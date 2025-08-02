{ pkgs, ... }:

{
  imports = [
    ./programs/_1password-shell-plugins
    ./programs/bat
    ./programs/carapace
    ./programs/direnv
    ./programs/fish
    ./programs/fzf
    ./programs/gh
    ./programs/git
    ./programs/karabiner
    ./programs/nh
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
    btop
    colima
    docker
    docker-credential-helpers
    eza
    fastfetch
    fd
    ffmpeg
    jq
    nixfmt
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
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense,carapace";
  };
}
