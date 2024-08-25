{
  inputs,
  system,
  ...
}: {
  imports = with inputs; [
    ./configuration.nix
    ../../modules/linux/gaming
    ../../modules/linux/audio
    ../../modules/linux/networking
    ../../modules/linux/fonts
    ../../modules/linux/greeter
    ../../modules/linux/core
    ../../modules/linux/hamachi
    ../../overlays

    catppuccin.nixosModules.catppuccin
    lix-module.nixosModules.default
    lanzaboote.nixosModules.lanzaboote
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit inputs;
        inherit system;
      };
      home-manager.users.youwen = {
        imports = [
          ../../users/youwen/linux/desktop
          ../../users/youwen/linux/packages/x86_64
          ../../users/youwen/linux/programs
          ../../users/youwen/common/neofetch
          ../../users/youwen/common
          ../../users/youwen/linux/spicetify
          ./home-manager-extras
          catppuccin.homeManagerModules.catppuccin
          neovim-config.homeManagerModules.default
        ];
      };
    }
  ];
}
