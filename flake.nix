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
    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, catppuccin, lanzaboote, stablepkgs
    , bleedingpkgs, lix-module, nix-darwin, nix-homebrew, apple-silicon, ...
    }@inputs: rec {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        demeter = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/demeter
            ./modules/nixos/gaming
            ./modules/nixos/audio
            ./modules/nixos/networking
            ./modules/nixos/fonts
            ./modules/nixos/greeter

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
                  ./users/youwen/linux/desktop
                  ./users/youwen/linux/packages/x86_64
                  ./users/youwen/linux/programs
                  ./users/youwen/common/neofetch
                  ./users/youwen/common
                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
        callisto = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "aarch64-linux";
          modules = [
            ./hosts/callisto
            ./modules/nixos/audio
            ./modules/nixos/networking
            ./modules/nixos/fonts
            ./modules/nixos/greeter

            apple-silicon.nixosModules.apple-silicon-support
            catppuccin.nixosModules.catppuccin
            lix-module.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.youwen = {
                imports = [
                  ./users/youwen/common
                  ./users/youwen/common/neofetch/asahi-only.nix
                  ./users/youwen/linux/laptop
                  ./users/youwen/linux/packages/aarch-64

                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
        adrastea = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/adrastea
            ./modules/nixos/gaming
            ./modules/nixos/audio
            ./modules/nixos/networking
            ./modules/nixos/fonts
            ./modules/nixos/greeter

            catppuccin.nixosModules.catppuccin
            lix-module.nixosModules.default
            # lanzaboote.nixosModules.lanzaboote
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.youwen = {
                imports = [
                  ./users/youwen/linux/laptop
                  ./users/youwen/linux/packages/x86_64
                  ./users/youwen/linux/programs
                  ./users/youwen/common
                  ./users/youwen/common/neofetch
                  ./hosts/adrastea/home-manager-overrides.nix
                  inputs.catppuccin.homeManagerModules.catppuccin
                ];
              };
            }
          ];
        };
      };
      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt;
      formatter.aarch64-linux = nixpkgs.legacyPackages.aarch64-linux.nixfmt;
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Youwens-MacBook-Pro
      darwinConfigurations.phobos = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/phobos
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.youwen.imports = [
              ./users/youwen/darwin/darwin-home.nix
              ./users/youwen/common/core.nix
              ./users/youwen/common/neofetch
            ];
            home-manager.backupFileExtension = "backup";

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/darwin/homebrew.nix
          ./modules/darwin/yabai.nix
          ./modules/darwin/skhd.nix
        ];
      };
    };
}
