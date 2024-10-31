{
  description = "System configuration flake.";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    apple-silicon = {
      # url = "github:tpwrules/nixos-apple-silicon";
      url = "github:zzywysm/nixos-asahi";
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

    stylix.url = "github:danth/stylix";

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
    inputs@{
      nixpkgs,
      nix-darwin,
      flake-parts,
      ...
    }:
    let
      buildLiminalOS = import ./lib/buildLiminalOS.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      flake = {
        nixosConfigurations = {
          demeter = buildLiminalOS {
            inherit inputs nixpkgs;
            systemModule = ./hosts/demeter;
          };
          callisto = buildLiminalOS {
            inherit nixpkgs inputs;
            systemModule = ./hosts/callisto;
          };
          adrastea = buildLiminalOS {
            inherit inputs nixpkgs;
            systemModule = ./hosts/adrastea;
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
      perSystem =
        { pkgs, system, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          devShells.default = pkgs.mkShell {
            buildInputs =
              with pkgs;
              [
                nixd
                nixfmt-rfc-style
                prettierd
                taplo
                marksman
              ]
              ++ [
                inputs.viminal.packages.${system}.default
              ];
          };
        };
    };
}
