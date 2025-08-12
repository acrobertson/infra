{ ... }:

{
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

  # TODO: 1password?
  programs.fish.enable = true;
}
