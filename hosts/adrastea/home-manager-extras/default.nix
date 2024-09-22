{ pkgs, ... }:
{
  wayland.windowManager.hyprland.settings.monitor = pkgs.lib.mkForce [
    # "eDP-1,2560x1440@165,0x0,1.6"
    "eDP-1, disable"
    "DP-3,2560x1440@165,0x0,1.0"
  ];
}
