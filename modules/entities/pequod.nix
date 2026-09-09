{ den, ... }:

{
  den.hosts.aarch64-darwin.pequod = {
    users.alecrobertson = { };
  };

  den.aspects.pequod = {
    includes = [
      den.aspects.platform-defaults
      den.aspects.darwin-home
      den.aspects.darwin-homebrew
    ];

    darwin = {
      system = {
        # Used for backwards compatibility, please read the changelog before changing.
        stateVersion = 5;

        defaults = {
          # Mouse tracking speed: Fast
          ".GlobalPreferences"."com.apple.mouse.scaling" = 3.0;
          # Trackpad tracking speed: Fast
          NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
          # Delay until key repeat: Short
          NSGlobalDomain.InitialKeyRepeat = 15;
          # Key repeat rate: Fast
          NSGlobalDomain.KeyRepeat = 2;
          # Automatically hide and show the dock
          dock.autohide = true;
        };

        primaryUser = "alecrobertson";
      };

      users.users.alecrobertson = {
        name = "alecrobertson";
        home = "/Users/alecrobertson";
      };
    };
  };

  # Host-scoped Home Manager user config, activated with the host (ADR-0004).
  den.aspects.alecrobertson.provides.pequod.homeManager =
    { pkgs, ... }:
    {
      programs.home-manager.enable = true;

      # ccusage is host-scoped: installed where the development aspect's
      # claude-code statusline is used.
      home.packages = [ pkgs.unstable.ccusage ];

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "23.11";
    };
}
