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
