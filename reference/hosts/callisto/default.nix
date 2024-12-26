{
  self,
  inputs,
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
      apple-silicon.nixosModules.apple-silicon-support
    ]);
}
