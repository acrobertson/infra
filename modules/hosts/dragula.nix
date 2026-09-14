{ den, ... }:

{
  den.hosts.aarch64-darwin.dragula = {
    users.alecrobertson = { };
  };

  den.aspects.dragula = {
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

  den.aspects.alecrobertson.provides.dragula.homeManager =
    { ... }:
    {
      programs.home-manager.enable = true;

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "26.05";
    };
}
