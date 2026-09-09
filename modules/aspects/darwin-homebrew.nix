{ inputs, ... }:

{
  # Shared Homebrew policy for darwin hosts.
  den.aspects.darwin-homebrew.darwin = {
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

    homebrew = {
      enable = true;
      # Disabled due to a `mas` issue
      # https://github.com/nix-darwin/nix-darwin/issues/1627
      # masApps = {
      #   "1Password for Safari" = 1569813296;
      #   Xcode = 497799835;
      # };
    };
  };
}
