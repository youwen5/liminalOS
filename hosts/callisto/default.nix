{
  inputs,
  system,
  ...
}: {
  imports = with inputs; [
    ./configuration.nix
    ../../modules/nixos/audio
    ../../modules/nixos/networking
    ../../modules/nixos/fonts
    ../../modules/nixos/greeter
    ../../modules/nixos/core
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
          ../../users/youwen/common/neovim
          ./home-manager-extras

          inputs.catppuccin.homeManagerModules.catppuccin
          inputs.nixvim.homeManagerModules.nixvim
        ];
      };
    }
  ];
}
