{
  description = "System configuration flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stablepkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    bleedingpkgs.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # firefox-addons = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

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

    spicetify = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    personal-neovim.url = "github:youwen5/neovim-flake";

    vesktop-bin.url = "github:youwen5/vesktop-bin-flake";

    wallpapers = {
      url = "git+https://code.youwen.dev/youwen5/wallpapers";
      flake = false;
    };

    zen-browser.url = "github:youwen5/zen-browser-flake";

    manga-tui.url = "github:josueBarretogit/manga-tui";
  };

  outputs = {
    nixpkgs,
    nix-darwin,
    ...
  } @ inputs: let
  in {
    formatter = with nixpkgs.legacyPackages; {
      x86_64-linux = x86_64-linux.alejandra;
      aarch64-linux = aarch64-linux.alejandra;
      aarch64-darwin = aarch64-darwin.alejandra;
    };

    nixosConfigurations = {
      demeter = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/demeter
        ];
      };

      callisto = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/callisto
        ];
      };
      adrastea = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
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
