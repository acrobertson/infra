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
      ];

      home-manager = {
        useUserPackages = true;
        # Back up colliding dotfiles on the first switch after migrating away
        # from the standalone home (docs/runbooks/pequod-hm-migration.md).
        backupFileExtension = "backup";

        users.alecrobertson =
          { osConfig, ... }:
          {
            # Den's unfree battery resolves with class "user" in host-user
            # contexts and emits only to the OS class, so the integrated
            # home's own pkgs (useGlobalPkgs is false) never see the
            # allowlist. Mirror it from the host.
            unfree.packages = osConfig.unfree.packages or [ ];
          };
      };

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
