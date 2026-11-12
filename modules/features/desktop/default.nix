{ den, inputs, ... }:

{
  den.aspects.desktop = {
    includes = [
      (den.batteries.unfree [
        "keymapp"
        "raycast"
        "shortcat"
      ])
    ];

    darwin.homebrew = {
      brews = [ "displayplacer" ];
      casks = [
        "mikker/tap/dinky"
        "figma"
        "handy"
        "karabiner-elements"
        "polypane"
        "slack"
      ];
    };

    homeManager =
      {
        lib,
        osConfig,
        pkgs,
        ...
      }:
      let
        # hodor (NixOS-WSL) has no GUI session; skip browsers there.
        isWsl = (osConfig.wsl or { }).enable or false;
      in
      {
        home.packages =
          lib.optionals pkgs.stdenv.isDarwin (
            with pkgs;
            [
              keymapp
              raycast
              # dontStrip: shortcat uses plain stdenv, so fixup strips the app
              # binary and Nix re-signs it ad-hoc, breaking the upstream
              # Developer ID signature (re-prompts TCC permissions on every
              # rebuild). keymapp/raycast are already guarded (stdenvNoCC /
              # dontFixup in nixpkgs).
              (shortcat.overrideAttrs (_: {
                dontStrip = true;
              }))
            ]
          )
          ++ lib.optionals (!isWsl) [
            # dontFixup: Nix's fixup phase strips Mach-O binaries and patches
            # shebangs (e.g. the framework's Resources/install.sh); both break
            # the upstream Developer ID signature's sealed resources, and
            # Gatekeeper then reports the app as "damaged". Skipping fixup
            # keeps the imput LLC signature + notarization intact, which
            # 1Password also requires for its browser integration.
            (inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
              dontFixup = true;
            }))
          ];

        xdg.configFile."dinky/dinky.toml" = lib.mkIf pkgs.stdenv.isDarwin {
          source = ./dinky.toml;
        };

        xdg.configFile."karabiner.edn" = lib.mkIf pkgs.stdenv.isDarwin {
          source = ./karabiner.edn;
          onChange = "${pkgs.goku}/bin/goku";
        };
      };
  };
}
