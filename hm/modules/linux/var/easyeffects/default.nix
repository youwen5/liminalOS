{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.liminalOS.utils.easyeffects;
in
{
  options.liminalOS.utils.easyeffects = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable EasyEffects.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.easyeffects.enable = true;

    home.file = lib.mkIf (osConfig.liminalOS.flakeLocation != null) {
      ".config/easyeffects/output" = {
        source = config.lib.file.mkOutOfStoreSymlink "${osConfig.liminalOS.flakeLocation}/hm/modules/linux/var/easyeffects/output";
        recursive = true;
      };
      ".config/easyeffects/input" = {
        source = config.lib.file.mkOutOfStoreSymlink "${osConfig.liminalOS.flakeLocation}/hm/modules/linux/var/easyeffects/input";
        recursive = true;
      };
    };
  };
}
