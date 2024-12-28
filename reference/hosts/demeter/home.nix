{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,2560x1440@144,1920x0,auto"
    "HDMI-A-1,1920x1080@60,0x0,1"
  ];

  programs.hyprlock.settings.background.monitor = lib.mkForce "DP-1";
}
