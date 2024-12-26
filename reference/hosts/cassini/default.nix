{
  inputs,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../modules/linux/core
      ../../modules/linux/stylix
      ../../overlays
      ../../modules/linux/wsl
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs;
        };
        home-manager.users.youwen = {
          imports =
            [
              ./home-manager-extras
              ../../users/youwen/common
              ../../users/youwen/linux/theming
              ../../users/youwen/linux/home.nix
              (import ../../users/youwen/common/fastfetch { kitty = false; })
            ]
            ++ (with inputs; [
              nix-index-database.hmModules.nix-index
            ]);
        };
      }
    ]
    ++ (with inputs; [
      home-manager.nixosModules.home-manager
    ]);
}
