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

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

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

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    ucode.url = "github:e-tho/ucodenix";

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
      inputs.flake-parts.follows = "flake-parts";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nix-index-database = {
      url = "github:marienz/nix-index-database";
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

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      flake-parts,
      self,
      ...
    }:
    let
      buildLiminalOS = import ./lib/buildLiminalOS.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        # "aarch64-darwin"
        # aarch64-darwin is currently disabled due to lack of maintenance
      ];
      flake = {
        nixosConfigurations = {
          demeter = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs self;
            };
            modules = [
              ./reference/hosts/demeter
            ];
          };
          callisto = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs self;
            };
            modules = [
              ./reference/hosts/callisto
            ];
          };
          adrastea = buildLiminalOS {
            inherit inputs nixpkgs;
            systemModule = ./reference/hosts/adrastea;
          };
          cassini = buildLiminalOS {
            inherit inputs nixpkgs;
            systemModule = ./reference/hosts/cassini;
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

        nixosModules = rec {
          default = liminalOS;
          liminalOS = {
            imports = [
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.home-manager.nixosModules.home-manager
              inputs.nixos-wsl.nixosModules.default
              inputs.stylix.nixosModules.stylix
              ./modules/default.nix
              ./overlays
              (
                { pkgs, ... }:
                {
                  home-manager.extraSpecialArgs = {
                    spicepkgs = inputs.spicetify.legacyPackages.${pkgs.system};
                    inherit inputs self;
                  };
                  nixpkgs.overlays = [
                    (final: prev: {
                      zen-browser = inputs.zen-browser.packages.${pkgs.system}.default;
                    })
                  ];
                }
              )
            ];
          };
        };

        homeManagerModules = rec {
          default = liminalOS;
          liminalOS = {
            imports = [
              inputs.nix-index-database.hmModules.nix-index
              inputs.spicetify.homeManagerModules.default
              ./hm/modules/default.nix
            ];
          };
        };

        templates = rec {
          liminalOS = {
            path = ./templates/liminalOS;
            description = "Barebones configuration of liminalOS";
          };
          default = liminalOS;
        };
      };
      perSystem =
        {
          pkgs,
          ...
        }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixd
              nixfmt-rfc-style
              prettierd
              taplo
              marksman
            ];
          };
        };
    };
}
