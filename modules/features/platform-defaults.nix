{ config, ... }:

let
  nixSettings = {
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
in
{
  den.aspects.platform-defaults = {
    darwin =
      { pkgs, ... }:
      {
        # Durable local builder for aarch64-linux and Rosetta-translated
        # x86_64-linux builds. The VZ backend isn't on the 26.05
        # release line yet, so take it from the pinned unstable input.
        nix = nixSettings // {
          linux-builder = {
            enable = true;
            systems = [
              "aarch64-linux"
              "x86_64-linux"
            ];
            package = (pkgs.extend config.flake.overlays.unstable-pkgs).unstable.darwin.linux-builder-vz;
          };
        };
      };

    nixos.nix = nixSettings;
  };
}
