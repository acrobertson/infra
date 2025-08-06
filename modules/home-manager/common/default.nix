{
  lib,
  userConfig,
  pkgs,
  ...
}:

{
  imports = [
    ../programs/_1password-shell-plugins
    ../programs/bat
    ../programs/carapace
    ../programs/direnv
    ../programs/fish
    ../programs/fzf
    ../programs/gh
    ../programs/ghostty
    ../programs/git
    ../programs/karabiner
    ../programs/nh
    ../programs/nushell
    ../programs/nvim
    ../programs/starship
    ../programs/taskwarrior
    ../programs/tmux
    ../programs/yazi
    ../programs/zoxide
    ../programs/zsh
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "1password-cli"
          "raycast"
          "shortcat"
        ];
    };
  };

  home = {
    username = "${userConfig.name}";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/${userConfig.name}" else "/home/${userConfig.name}";
  };

  home.packages =
    with pkgs;
    [
      btop
      curl
      eza
      fastfetch
      fd
      ffmpeg
      jq
      nixfmt
      nodejs
      pandoc
      ripgrep
      sd
      timewarrior
      tldr
      wget
    ]
    ++ lib.optionals stdenv.isDarwin [
      colima
      docker
      docker-credential-helpers
      raycast
      shortcat
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense,carapace";
  };
}
