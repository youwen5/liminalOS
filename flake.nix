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

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    ucode.url = "github:e-tho/ucodenix";

    apple-silicon = {
      # url = "github:zzywysm/nixos-asahi";
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-firmware = {
      url = "github:youwen5/apple-firmware";
      flake = false;
    };

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    textfox = {
      url = "github:youwen5/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur.follows = "nur";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
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
          adrastea = nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs self;
            };
            modules = [
              ./reference/hosts/adrastea
            ];
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
              inputs.agenix.nixosModules.age
              inputs.musnix.nixosModules.musnix
              inputs.nur.modules.nixos.default
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
                  # instead of using ragenix from agenix which builds from
                  # source, use ragenix packaged in nixpkgs
                  environment.systemPackages = [ pkgs.ragenix ];
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
              inputs.agenix.homeManagerModules.age
              inputs.textfox.homeManagerModules.textfox
              ./hm/modules/default.nix
            ];
          };
        };

        templates = rec {
          liminalOS = {
            path = ./templates/minimal;
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

          packages.docs = pkgs.callPackage ./docs { };
        };
    };
}
