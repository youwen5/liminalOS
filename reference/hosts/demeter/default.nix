{
  inputs,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../../modules/linux
      ../../../hm
      ../../../overlays
      {
        home-manager.users.youwen = {
          imports = [ ./home.nix ];
        };
      }
    ]
    ++ (with inputs; [
      lanzaboote.nixosModules.lanzaboote
    ]);
}
