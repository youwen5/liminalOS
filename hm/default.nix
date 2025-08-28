{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.functorOS;
in
{
  options.functorOS.integrateHomeManager = lib.mkOption {
    type = lib.types.bool;
    default = cfg.enable;
    description = ''
      Whether to activate home manager with default options. Keep in mind you still have to import the functorOS home-manager module.
    '';
  };

  config.home-manager = lib.mkIf cfg.integrateHomeManager {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}