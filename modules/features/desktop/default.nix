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
        "ungoogled-chromium"
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
            inputs.helium.packages.${pkgs.system}.default
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
