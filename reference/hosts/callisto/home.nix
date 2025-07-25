{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  liminalOS.desktop.hyprland.screenlocker.monitor = "eDP-1";
  liminalOS.desktop.hyprland.screenlocker.useCrashFix = true;
}
