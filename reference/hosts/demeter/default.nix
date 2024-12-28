{
  inputs,
  self,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../secrets
      self.nixosModules.liminalOS
      {
        home-manager.users.youwen = {
          imports = [
            ./home.nix
            self.homeManagerModules.default
          ];
        };
      }
    ]
    ++ (with inputs; [
      lanzaboote.nixosModules.lanzaboote
    ]);
}
