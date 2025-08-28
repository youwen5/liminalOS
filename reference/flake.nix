{
  inputs = {
    functorOS.url = "git+https://code.functor.systems/functor.systems/functorOS.git";
    nixpkgs.follows = "functorOS/nixpkgs";
    viminal.url = "github:youwen5/viminal2";
    wallpapers = {
      url = "github:youwen5/wallpapers";
      flake = false;
    };
    zenTyp.url = "github:youwen5/zen.typ";
    valkyrie = {
      url = "github:youwen5/valkyrie";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    iamb = {
      url = "github:youwen5/iamb";
      inputs.flake-utils.follows = "functorOS/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "functorOS/flake-parts";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      ...
    }:
    {
      nixosConfigurations = {
        demeter = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit self inputs;
          };
          modules = [
            ./hosts/demeter
          ];
        };
      };
    };
}
