{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,2560x1440@144,0x0,auto"
  ];

  liminalOS.desktop.hyprland.screenlocker.monitor = "DP-1";
}
