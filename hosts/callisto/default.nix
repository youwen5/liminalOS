{
  inputs,
  system,
  ...
}:
{
  imports = with inputs; [
    ./configuration.nix
    ../../modules/linux/audio
    ../../modules/linux/networking
    ../../modules/linux/fonts
    ../../modules/linux/greeter
    ../../modules/linux/core
    ../../modules/linux/desktop-portal
    ../../overlays

    apple-silicon.nixosModules.apple-silicon-support
    catppuccin.nixosModules.catppuccin
    lix-module.nixosModules.default
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
          ../../users/youwen/common
          ../../users/youwen/linux/laptop
          ../../users/youwen/linux/packages/aarch-64
          ../../users/youwen/common/fastfetch
          ./home-manager-extras
          catppuccin.homeManagerModules.catppuccin
        ];
      };
    }
  ];
}
