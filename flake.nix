{
  description = "System configuration flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stablepkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    bleedingpkgs.url = "github:nixos/nixpkgs/master";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url =
        "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, lanzaboote, stablepkgs
    , bleedingpkgs, lix-module, nix-darwin, nix-homebrew, ... }@inputs: rec {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos
            ./modules/nixos/secureboot.nix
            ./modules/nixos/gaming.nix
            ./modules/nixos/audio.nix
            ./modules/nixos/nvidia.nix
            ./modules/nixos/networking.nix
            ./modules/common/fonts.nix

            catppuccin.nixosModules.catppuccin

            lix-module.nixosModules.default

            lanzaboote.nixosModules.lanzaboote

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.youwen = {
                imports = [
                  ./users/youwen/linux/linux-home.nix
                  ./users/youwen/linux/desktop.nix
                  ./users/youwen/linux/programs.nix
                  ./users/youwen/common/core.nix
                  ./users/youwen/linux/catppuccin.nix
                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
        callisto = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/callisto
            # ./modules/nixos/secureboot.nix
            # ./modules/nixos/gaming.nix
            # ./modules/nixos/audio.nix
            # ./modules/nixos/nvidia.nix
            # ./modules/nixos/networking.nix
            # ./modules/common/fonts.nix

            catppuccin.nixosModules.catppuccin

            # lix-module.nixosModules.default

            # lanzaboote.nixosModules.lanzaboote

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.youwen = {
                imports = [
                  # ./users/youwen/linux/linux-home.nix
                  # ./users/youwen/linux/desktop.nix
                  # ./users/youwen/linux/programs.nix
                  # ./users/youwen/common/core.nix
                  # ./users/youwen/linux/catppuccin.nix
                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
      };
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Youwens-MacBook-Pro
      darwinConfigurations."Youwens-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./modules/darwin/darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.youwen.imports = [
              ./users/youwen/darwin/darwin-home.nix
              ./users/youwen/common/core.nix
            ];
            home-manager.backupFileExtension = "backup";

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/darwin/homebrew.nix
          ./modules/darwin/yabai.nix
        ];
      };
    };
}
