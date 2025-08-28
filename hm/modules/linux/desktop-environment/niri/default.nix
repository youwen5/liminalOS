{ lib, config, ... }:
let
  cfg = config.functorOS.desktop.niri;
in
{
  options.functorOS.desktop.niri = {
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