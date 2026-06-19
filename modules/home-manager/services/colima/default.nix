{ pkgs, ... }:

{
  services.colima = {
    enable = pkgs.stdenv.isDarwin;
  };
}
