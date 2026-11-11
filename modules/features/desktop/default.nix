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
              shortcat
            ]
          )
          ++ lib.optionals (!isWsl) [
            # dontStrip: Nix's fixup phase strips Mach-O binaries under
            # Applications/, invalidating the upstream Developer ID signature
            # (which gets replaced by an ad-hoc one). Skipping the strip keeps
            # the imput LLC signature + notarization intact, which 1Password
            # requires for its browser integration.
            (inputs.helium.packages.${pkgs.system}.default.overrideAttrs (_: {
              dontStrip = true;
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
