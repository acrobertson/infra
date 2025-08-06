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

  homebrew = {
    enable = true;
    casks = [
      "figma"
      "karabiner-elements"
      "polypane"
      "slack"
      "ungoogled-chromium"
    ];
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  # TODO: enable karabiner service

  security = {
    pam.services.sudo_local.touchIdAuth = true;
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
