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
      # ../../modules/linux/spotifyd
      ../../modules/linux/core
      ../../modules/linux/desktop-portal
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
              ../../users/youwen/common/fastfetch
              ./home-manager-extras
            ]
            ++ (with inputs; [
              nix-index-database.hmModules.nix-index
            ]);
        };
      }
    ]
    ++ (with inputs; [
      lix-module.nixosModules.default
      home-manager.nixosModules.home-manager
      apple-silicon.nixosModules.apple-silicon-support

    ]);
}
