{ inputs, ... }:

{
  # When applied, the unstable nixpkgs set will
  # be accessible through 'pkgs.unstable'
  unstable-pkgs = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system config;
    };
  };
}
