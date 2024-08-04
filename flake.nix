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
    , bleedingpkgs, lix-module, ... }@inputs: {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./modules/nixos/secureboot.nix

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
                ./home.nix
                ./modules/home-manager/linux/desktop.nix
                catppuccin.homeManagerModules.catppuccin
              ];
            };
          }
        ];
      };
    };
}
