{
  inputs,
  system,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../modules/linux/audio
      ../../modules/linux/networking
      ../../modules/linux/fonts
      ../../modules/linux/greeter
      ../../modules/linux/core
      ../../modules/linux/desktop-environment
      ../../modules/linux/stylix
      ../../overlays
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs;
          inherit system;
        };
        home-manager.users.youwen = {
          imports =
            [
              ../../users/youwen/common
              ../../users/youwen/linux/laptop
              ../../users/youwen/linux/packages/aarch-64
              (import ../../users/youwen/common/fastfetch { })
              ./home-manager-extras
            ]
            ++ (with inputs; [
              nix-index-database.hmModules.nix-index
            ]);
        };
      }
    ]
    ++ (with inputs; [
      home-manager.nixosModules.home-manager
      apple-silicon.nixosModules.apple-silicon-support
    ]);
}
