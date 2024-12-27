{
  inputs,
  self,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      self.nixosModules.default
      {
        home-manager.users.youwen = {
          imports = [
            self.homeManagerModules.default
          ];
        };
      }
    ]
    ++ (with inputs; [
      home-manager.nixosModules.home-manager
    ]);
}
