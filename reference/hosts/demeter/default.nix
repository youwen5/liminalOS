{
  inputs,
  self,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../modules
      ../../secrets
      ../../users/youwen/nixos.nix
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
