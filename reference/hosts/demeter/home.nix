{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,2560x1440@165,0x0,auto,bitdepth,10"
  ];
  wayland.windowManager.hyprland.settings.misc.vrr = 3;

  liminalOS.desktop.hyprland.screenlocker.monitor = "DP-1";
}
