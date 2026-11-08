{ den, inputs, ... }:

{
  den.aspects.authentication = {
    includes = [
      (den.batteries.unfree [
        "1password"
        "1password-cli"
      ])
    ];

    darwin = {
      programs._1password-gui.enable = true;

      security.pam.services.sudo_local = {
        reattach = true;
        touchIdAuth = true;
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        imports = [ inputs._1password-shell-plugins.hmModules.default ];

        # Shell plugins drive the 1Password GUI/CLI app integration, which
        # does not exist headless on Linux/WSL.
        programs._1password-shell-plugins = {
          enable = pkgs.stdenv.isDarwin;
          plugins = with pkgs; [ gh ];
        };
      };
  };
}
