{
  inputs,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../modules
      inputs.functorOS.nixosModules.default
      {
        home-manager.users.youwen = {
          imports = [
            ./home.nix
            inputs.functorOS.homeManagerModules.default
          ];
        };
      }
    ]
    ++ (with inputs; [
      lanzaboote.nixosModules.lanzaboote
    ]);
}
