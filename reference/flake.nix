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
    textfox = {
      url = "github:youwen5/textfox";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nur.follows = "nur";
    };
    nur = {
      url = "github:nix-community/NUR";
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
    let
      functorLib = (import inputs.functorOS) { inherit self nixpkgs inputs; };

      userYouwen = functorLib.user.instantiate' {
        username = "youwen";
        homeDirectory = "/home/youwen";
        fullName = "Youwen Wu";
        email = "youwenw@gmail.com";
        configureGitUser = true;
        configuration.imports = [ ./users/youwen/hm.nix ];
        initialHashedPassword = "$y$j9T$v0OkEeCntj8KwgPJQxyWx0$dx8WtFDYgZZ8WE3FWetWwRfutjQkznRuJ0IG3LLAtP2";
      };
    in
    {
      nixosConfigurations = {
        demeter = functorLib.system.instantiate {
          hostname = "demeter";
          configuration.imports = [ ./hosts/demeter ];
          users = [
            (userYouwen ./hosts/demeter/home.nix)
          ];
        };
      };
    };
}
