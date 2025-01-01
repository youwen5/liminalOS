{
  description = "Test standalone liminalOS system";

  inputs = {
    # Follow the nixpkgs in liminalOS, which is verified to build properly before release.
    nixpkgs.follows = "liminalOS/nixpkgs";
    liminalOS.url = "github:youwen5/liminalOS/modules-refactor";

    # Alternatively, pin your own nixpkgs and set liminalOS to follow it, as shown below.

    # nixpkgs.follows = "github:nixos/nixpkgs?ref=nixos-unstable";
    # liminalOS.url = "github:youwen5/liminalOS/modules-refactor";
    # liminalOS.inputs.nixpkgs.follows = "nixpkgs";

    # Either way, you should ensure that liminalOS shares nixpkgs with your
    # system to avoid any weird conflicts.
  };

  outputs =
    inputs@{ nixpkgs, liminalOS, ... }:
    {
      # Execute sudo nixos-rebuild switch --flake .#liminalOS
      nixosConfigurations = {
        liminalOS = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            liminalOS.nixosModules.default
            ./configuration.nix
          ];
        };
      };
    };
}
