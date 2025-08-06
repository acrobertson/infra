{
  description = "Configs for my machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "darwin";
    };

    _1password-shell-plugins.url = "github:1Password/shell-plugins";

    neovim-config = {
      url = "github:acrobertson/neovim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      darwin,
      home-manager,
      nixpkgs,
      ...
    }:
    let
      inherit (self) outputs;

      users = {
        alecrobertson = {
          name = "alecrobertson";
          fullName = "Alec Robertson";
          email = "alec.robertson08@gmail.com";
        };
      };

      mkDarwinConfiguration =
        hostname: username:
        darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            darwinModules = "${self}/modules/darwin";
          };
          modules = [
            ./hosts/${hostname}
            inputs.nix-homebrew.darwinModules.nix-homebrew
            home-manager.darwinModules.home-manager
          ];
        };

      mkHomeConfiguration =
        system: username: hostname:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          extraSpecialArgs = {
            inherit inputs outputs;
            userConfig = users.${username};
            homeModules = "${self}/modules/home-manager";
          };
          modules = [
            ./home/${username}/${hostname}
          ];
        };
    in
    {
      darwinConfigurations = {
        "pequod" = mkDarwinConfiguration "pequod" "alecrobertson";
      };

      homeConfigurations = {
        "alecrobertson@pequod" = mkHomeConfiguration "aarch64-darwin" "alecrobertson" "pequod";
      };
    };
}
