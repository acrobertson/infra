{ lib, pkgs, ... }:

{
  den.aspects.containers.homeManager =
    { lib, pkgs, ... }:
    {
      services.colima.enable = pkgs.stdenv.isDarwin;

      home.packages = lib.optionals pkgs.stdenv.isDarwin (
        with pkgs;
        [
          unstable.container
          docker
          docker-credential-helpers
        ]
      );
    };
}
