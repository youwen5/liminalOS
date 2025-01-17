{ lib, config, ... }:
let
  cfg = config.liminalOS.desktop.niri;
in
{
  options.liminalOS.desktop.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable and rice Niri.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink ./config.kdl;
  };
}
