{
  lib,
  outputs,
  userConfig,
  pkgs,
  ...
}:

{
  imports = [
    ../programs/_1password-shell-plugins
    ../programs/bat
    ../programs/carapace
    ../programs/chromium
    ../programs/claude-code
    ../programs/delta
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
    ../programs/opencode
    ../programs/starship
    ../programs/taskwarrior
    ../programs/tmux
    ../programs/yazi
    ../programs/zoxide
    ../services/colima
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "1password-cli"
          "claude-code"
          "keymapp"
          "raycast"
          "shortcat"
        ];
    };
    overlays = [ outputs.overlays.unstable-pkgs ];
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
      unstable.ccusage
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
      rsync
      sd
      skills
      timewarrior
      tldr
      wget
    ]
    ++ lib.optionals stdenv.isDarwin [
      unstable.container
      docker
      docker-credential-helpers
      keymapp
      raycast
      shortcat
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    CARAPACE_BRIDGES = "zsh,fish,bash,inshellisense,carapace";
  };
}
