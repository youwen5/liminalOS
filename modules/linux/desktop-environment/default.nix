{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.desktop;
in
{
  options.liminalOS.desktop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to enable the liminalOS desktop environment.
      '';
    };
    hyprland.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable Hyprland. Sets up a default configuration at the system and user level, and installs xdg-desktop-portal-gtk.
      '';
    };
    niri.enable = lib.mkEnableOption "Niri compositor";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = lib.mkIf cfg.hyprland.enable {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    programs.hyprland.enable = cfg.hyprland.enable;

    programs.niri.enable = cfg.niri.enable;

    programs.xwayland.enable = lib.mkIf cfg.niri.enable (lib.mkForce true);

    services.xserver.enable = false;

    services.xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
}
