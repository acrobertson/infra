{
  lib,
  userConfig,
  ...
}:

{
  # add more system settings here
  nix = {
    optimise.automatic = true;
    settings = {
      builders-use-substitutes = true;
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://yazi.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
      ];
      trusted-users = [ "@wheel" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "1password"
        ];
    };
  };

  homebrew = {
    enable = true;
    brews = [
      "displayplacer"
    ];
    casks = [
      "figma"
      "karabiner-elements"
      "polypane"
      "slack"
      "ungoogled-chromium"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      Xcode = 497799835;
    };
  };

  programs._1password-gui.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;

  # TODO: enable karabiner service

  security.pam.services.sudo_local = {
    reattach = true;
    touchIdAuth = true;
  };

  system = {
    defaults = {
      # Mouse tracking speed: Fast
      ".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;
      # Trackpad tracking speed: Fast
      NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
      # Delay until key repeat: Short
      NSGlobalDomain.InitialKeyRepeat = 15;
      # Key repeat rate: Fast
      NSGlobalDomain.KeyRepeat = 2;
      # Automatically hide and show the dock
      dock.autohide = true;
    };

    primaryUser = userConfig.name;
  };

  users.users.${userConfig.name} = {
    name = "${userConfig.name}";
    home = "/Users/${userConfig.name}";
  };
}
