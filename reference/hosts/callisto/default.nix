{
  inputs,
  system,
  ...
}:
{
  imports =
    [
      ./configuration.nix
      ../../../modules/linux
      ../../../overlays
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
