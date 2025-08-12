{
  description = "Configs for my machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
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
      nixos-wsl,
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
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = username;
                autoMigrate = true;
              };
            }
            home-manager.darwinModules.home-manager
          ];
        };

      mkWslConfiguration =
        hostname: username:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs outputs hostname;
            userConfig = users.${username};
            wslModules = "${self}/modules/wsl";
          };
          modules = [
            ./hosts/${hostname}
            nixos-wsl.nixosModules.default
            {
              wsl = {
                enable = true;
                defaultUser = username;
                startMenuLaunchers = true;
              };
            }
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

      nixosConfigurations = {
        "hodor" = mkWslConfiguration "hodor" "alecrobertson";
      };

      homeConfigurations = {
        "alecrobertson@pequod" = mkHomeConfiguration "aarch64-darwin" "alecrobertson" "pequod";
      };
    };
}
