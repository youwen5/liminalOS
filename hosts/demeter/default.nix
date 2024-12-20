{
  inputs,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../modules/linux/gaming
      ../../modules/linux/audio
      ../../modules/linux/networking
      ../../modules/linux/fonts
      ../../modules/linux/greeter
      ../../modules/linux/core
      ../../modules/linux/hamachi
      ../../modules/linux/desktop-portal
      ../../modules/linux/audio-prod
      ../../modules/linux/stylix
      ../../modules/linux/wine
      ../../modules/linux/flatpak
      ../../overlays
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
              ../../users/youwen/linux/laptop
              ../../users/youwen/linux/packages/x86_64
              ../../users/youwen/linux/programs
              (import ../../users/youwen/common/fastfetch { })
              ../../users/youwen/common
              ../../users/youwen/linux/spicetify
              ./home-manager-extras
            ]
            ++ (with inputs; [
              nix-index-database.hmModules.nix-index
            ]);
        };
      }
    ]
    ++ (with inputs; [
      lanzaboote.nixosModules.lanzaboote
      home-manager.nixosModules.home-manager
    ]);
}
