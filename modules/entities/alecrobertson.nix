{
  config,
  den,
  inputs,
  ...
}:
let
  userConfig = {
    name = "alecrobertson";
    fullName = "Alec Robertson";
    email = "alec.robertson08@gmail.com";
  };

  overlays = config.flake.overlays;
in
{
  den.aspects.alecrobertson = {
    includes = [
      den.batteries.define-user
      den.aspects.shell
      den.aspects.nix-tools
      den.aspects.terminal
      den.aspects.git
      den.aspects.development
      den.aspects.containers
      den.aspects.desktop
      den.aspects.authentication
    ];

    homeManager =
      { pkgs, ... }:
      {
        _module.args = {
          inherit overlays;
          inputs = inputs;
          "inputs'" = inputs;
          inherit userConfig;
        };

        nixpkgs.overlays = [ overlays.unstable-pkgs ];

        home = {
          username = userConfig.name;
          homeDirectory =
            if pkgs.stdenv.isDarwin then "/Users/${userConfig.name}" else "/home/${userConfig.name}";
        };
      };
  };
}
