{ den, inputs, ... }:

{
  den.hosts.aarch64-darwin.pequod = {
    users.alecrobertson = { };
  };

  den.aspects.pequod = {
    includes = [ den.aspects.platform-defaults ];

    darwin = {
      imports = [
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "alecrobertson";
            autoMigrate = true;
          };
        }
        inputs.home-manager.darwinModules.home-manager
      ];

      homebrew = {
        enable = true;
        # Disabled due to a `mas` issue
        # https://github.com/nix-darwin/nix-darwin/issues/1627
        # masApps = {
        #   "1Password for Safari" = 1569813296;
        #   Xcode = 497799835;
        # };
      };

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
}
