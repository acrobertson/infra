{
  inputs,
  username,
}:
system:
let
  system-config = import ../module/configuration.nix;
  home-manager-config = import ../module/home-manager;
in
inputs.darwin.lib.darwinSystem {
  inherit system;
  # modules: allows for reusable code
  modules = [
    {
      users.users.${username}.home = "/Users/${username}";
    }
    system-config

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = home-manager-config;
    }

    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nix-homebrew = {
        # Install Homebrew under the default prefix
        enable = true;
        # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
        enableRosetta = true;
        # User owning the Homebrew prefix
        user = username;
        # Automatically migrate existing Homebrew installations
        autoMigrate = true;
      };
    }
  ];
}
