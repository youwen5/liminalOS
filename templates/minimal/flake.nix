{
  description = "Test standalone functorOS system";

  inputs = {
    # Follow the nixpkgs in functorOS, which is verified to build properly before release.
    nixpkgs.follows = "functorOS/nixpkgs";
    functorOS.url = "github:youwen5/functorOS/modules-refactor";

    # Alternatively, pin your own nixpkgs and set functorOS to follow it, as shown below.

    # nixpkgs.follows = "github:nixos/nixpkgs?ref=nixos-unstable";
    # functorOS.url = "github:youwen5/functorOS/modules-refactor";
    # functorOS.inputs.nixpkgs.follows = "nixpkgs";

    # Either way, you should ensure that functorOS shares nixpkgs with your
    # system to avoid any weird conflicts.
  };

  outputs =
    inputs@{ nixpkgs, functorOS, ... }:
    {
      # Execute sudo nixos-rebuild switch --flake .#functorOS
      nixosConfigurations = {
        functorOS = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            functorOS.nixosModules.default
            ./configuration.nix
          ];
        };
      };
    };
}