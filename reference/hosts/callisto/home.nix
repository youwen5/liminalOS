{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  functorOS.desktop.hyprland.screenlocker.monitor = "eDP-1";
  functorOS.desktop.hyprland.screenlocker.useCrashFix = true;

  wayland.windowManager.hyprland.settings.env = [
    "GSK_RENDERER,ngl"
  ];
}