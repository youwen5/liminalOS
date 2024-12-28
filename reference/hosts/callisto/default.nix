{
  self,
  inputs,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../modules
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
      apple-silicon.nixosModules.apple-silicon-support
    ]);
}
