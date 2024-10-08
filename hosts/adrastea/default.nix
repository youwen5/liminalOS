{
  inputs,
  system,
  ...
}:
{
  imports = with inputs; [
    ./configuration.nix
    ../../modules/linux/gaming
    ../../modules/linux/audio
    ../../modules/linux/networking
    ../../modules/linux/fonts
    ../../modules/linux/greeter
    ../../modules/linux/core
    ../../modules/linux/desktop-portal
    ../../modules/linux/desktop-portal
    ../../modules/linux/audio-prod
    ../../modules/linux/wine
    ../../overlays

    catppuccin.nixosModules.catppuccin
    lix-module.nixosModules.default
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };
      home-manager.users.youwen = {
        imports = [
          ./home-manager-extras
          ../../users/youwen/linux/laptop
          ../../users/youwen/linux/packages/x86_64
          ../../users/youwen/linux/programs
          ../../users/youwen/common
          ../../users/youwen/linux/spicetify
          ../../users/youwen/common/neofetch
          catppuccin.homeManagerModules.catppuccin
        ];
      };
    }
  ];
}
