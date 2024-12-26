{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.liminalOS.integrateHomeManager = lib.mkOption {
    type = lib.types.bool;
    default = cfg.enable;
    description = ''
      Whether to activate home manager with default options. Keep in mind you still have to import the liminalOS home-manager module.
    '';
  };

  config.home-manager = lib.mkIf cfg.integrateHomeManager {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
  };
}
