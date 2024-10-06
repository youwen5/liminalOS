{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings.monitor = pkgs.lib.mkForce [
    # "eDP-1,2560x1440@165,0x0,1.6"
    "eDP-1, disable"
    "HDMI-A-1,2560x1440@144,0x0,1.0"
  ];

  wayland.windowManager.hyprland.settings.env = [
    "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
  ];

  programs.waybar.settings.mainBar.output = "HDMI-A-1";
}
