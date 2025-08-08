{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,2560x1440@165,0x0,auto,bitdepth,10,cm,hdr"
  ];

  liminalOS.desktop.hyprland.screenlocker.monitor = "DP-1";
}
