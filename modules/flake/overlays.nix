{ inputs, ... }:

{
  flake.overlays.unstable-pkgs = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system config;
    };
  };
}
