{
  inputs,
  lib,
  config,
  osConfig,
  ...
}:
let
  cfg = config.liminalOS;
in
{
  options.liminalOS = {
    formFactor = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "laptop"
          "desktop"
        ]
      );
      default = osConfig.liminalOS.formFactor;
      description = ''
        Form factor of the machine. Adjusts some UI features. Inherited from system configuration liminalOS.formFactor if set, otherwise you must set it here.
      '';
    };
  };

  config = {
    services.tlp.enable = lib.mkIf (cfg.formFactor == "laptop") true;
    programs.light.enable = lib.mkIf (cfg.formFactor == "laptop") true;
    assertions = [
      {
        assertion = cfg.formFactor != null;
        message = "You must set liminalOS.formFactor either in the home-manager configuration for the user or in the OS configuration for the system!";
      }
    ];
  };
}
