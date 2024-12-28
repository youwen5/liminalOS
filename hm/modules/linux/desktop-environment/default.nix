{
  osConfig,
  lib,
  ...
}:
{
  imports = [
    ./hyprland
    ./waybar
    ./swaync.nix
  ];

  options.liminalOS.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.liminalOS.desktop.enable;
      description = ''
        Whether to enable the default configuration for the userland portions of the liminalOS desktop environment.
      '';
    };
  };
}
