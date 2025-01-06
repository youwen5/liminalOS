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
      ucode.nixosModules.default
    ]);
}
