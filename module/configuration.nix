{ lib, ... }:
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
          "1password-cli"
          "raycast"
          "shortcat"
        ];
    };
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  # TODO: enable karabiner service

  homebrew = {
    enable = true;
    casks = [
      "figma"
      "ghostty"
      "karabiner-elements"
      "polypane"
      "slack"
    ];
  };

  system = {
    stateVersion = 5;
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
  };
}
