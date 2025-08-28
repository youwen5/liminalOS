{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-3,2560x1440@165,0x0,auto,bitdepth,10"
  ];
  wayland.windowManager.hyprland.settings.misc.vrr = 3;

  functorOS.desktop.hyprland.screenlocker.monitor = "DP-3";
}