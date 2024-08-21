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

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.90.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    catppuccin,
    lanzaboote,
    stablepkgs,
    bleedingpkgs,
    lix-module,
    nix-darwin,
    nix-homebrew,
    apple-silicon,
    ...
  } @ inputs: let
  in rec {
    formatter = with nixpkgs.legacyPackages; {
      x86_64-linux = x86_64-linux.alejandra;
      aarch64-linux = aarch64-linux.alejandra;
      aarch64-darwin = aarch64-darwin.alejandra;
    };

    nixosConfigurations = {
      demeter = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          system = "x86_64-linux";
        };
        modules = [
          ./hosts/demeter
        ];
      };

      callisto = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          system = "aarch64-linux";
        };
        modules = [
          ./hosts/callisto
        ];
      };
      adrastea = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        system = "x86_64-linux";
        modules = [
          ./hosts/adrastea
        ];
      };
    };
    darwinConfigurations.phobos = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/phobos
      ];
    };
  };
}
