{ config, lib, ... }:

let
  # Root-on-x86_64-linux packing only: run with
  # `sudo nix run <repo>#hodor-wsl-tarball` from inside the WSL distro.
  tarballBuilder = config.flake.nixosConfigurations.hodor.config.system.build.tarballBuilder;
in
{
  perSystem =
    { system, ... }:
    lib.mkIf (system == "x86_64-linux") {
      packages.hodor-wsl-tarball = tarballBuilder;
    };
}
