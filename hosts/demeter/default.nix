{
  inputs,
  system,
  ...
}: {
  imports = with inputs; [
    ./configuration.nix
    ../../modules/nixos/gaming
    ../../modules/nixos/audio
    ../../modules/nixos/networking
    ../../modules/nixos/fonts
    ../../modules/nixos/greeter
    ../../modules/nixos/core
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
          ../../users/youwen/common/neovim
          ../../users/youwen/common
          ./home-manager-extras
          catppuccin.homeManagerModules.catppuccin
          nixvim.homeManagerModules.nixvim
        ];
      };
    }
  ];
}
