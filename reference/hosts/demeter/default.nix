{
  inputs,
  self,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      self.nixosModules.liminalOS
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
