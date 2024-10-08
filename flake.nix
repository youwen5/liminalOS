{
  description = "System configuration flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # stablepkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    # bleedingpkgs.url = "github:nixos/nixpkgs/master";
    # nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    apple-firmware = {
      url = "git+https://code.youwen.dev/youwen5/apple-firmware";
      flake = false;
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    viminal = {
      url = "git+https://code.youwen.dev/youwen5/viminal2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vesktop-bin = {
      url = "github:youwen5/vesktop-bin-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "git+https://code.youwen.dev/youwen5/wallpapers";
      flake = false;
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      ...
    }@inputs:
    let
    in
    {
      formatter = with nixpkgs.legacyPackages; {
        x86_64-linux = x86_64-linux.nixfmt-rfc-style;
        aarch64-linux = aarch64-linux.nixfmt-rfc-style;
        aarch64-darwin = aarch64-darwin.nixfmt-rfc-style;
      };

      nixosConfigurations = {
        demeter = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/demeter
          ];
        };

        callisto = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/callisto
          ];
        };
        adrastea = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/adrastea
          ];
        };
      };
      darwinConfigurations.phobos = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/phobos
        ];
      };
    };
}
