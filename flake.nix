{
  description = "System configuration flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stablepkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    catppuccin.url = "github:catppuccin/nix";
    # zimfw.url = "github:joedevivo/zimfw.nix";
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
    , lix-module, ... }@inputs: {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix

          catppuccin.nixosModules.catppuccin

          lix-module.nixosModules.default

          lanzaboote.nixosModules.lanzaboote
          ({ pkgs, lib, ... }: {
            environment.systemPackages = [
              # For debugging and troubleshooting Secure Boot.
              pkgs.sbctl
            ];

            # Lanzaboote currently replaces the systemd-boot module.
            # This setting is usually set to true in configuration.nix
            # generated at installation time. So we force it to false
            # for now.
            boot.loader.systemd-boot.enable = lib.mkForce false;

            boot.lanzaboote = {
              enable = true;
              pkiBundle = "/etc/secureboot";
            };
          })

          {
            nixpkgs.overlays = [
              (self: super: {
                easyeffects =
                  stablepkgs.legacyPackages.${self.system}.easyeffects;
              })
            ];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            # home-manager.sharedModules = [ zimfw.homeManagerModules.zimfw ];
            home-manager.users.youwen = {
              imports = [ ./home.nix catppuccin.homeManagerModules.catppuccin ];
            };
          }
        ];
      };
    };
}
