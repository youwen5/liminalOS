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
      buildFunctorOS = import ./lib/buildFunctorOS.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        # "aarch64-darwin"
        # aarch64-darwin is currently disabled due to lack of maintenance
      ];
      flake = {
        nixosModules = rec {
          default = functorOS;
          functorOS = {
            imports = [
              inputs.nix-flatpak.nixosModules.nix-flatpak
              inputs.home-manager.nixosModules.home-manager
              inputs.nixos-wsl.nixosModules.default
              inputs.stylix.nixosModules.stylix
              inputs.agenix.nixosModules.age
              inputs.musnix.nixosModules.musnix
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
          default = functorOS;
          functorOS = {
            imports = [
              inputs.nix-index-database.hmModules.nix-index
              inputs.spicetify.homeManagerModules.default
              inputs.agenix.homeManagerModules.age
              ./hm/modules/default.nix
            ];
          };
        };

        templates = rec {
          functorOS = {
            path = ./templates/minimal;
            description = "Barebones configuration of functorOS";
          };
          default = functorOS;
        };
      };
      perSystem =
        {
          pkgs,
          self',
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

          packages.docs-raw = pkgs.callPackage ./docs/raw.nix {
            hash = if (self ? rev) then self.rev else "placeholder_hash";
          };
          packages.docs-rendered = pkgs.callPackage ./docs/rendered.nix {
            inherit (self'.packages) docs-raw;
            title = ''functorOS module options for ${if (self ? rev) then self.rev else "placeholder_hash"})'';
          };
        };
    };
}

