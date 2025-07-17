{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  wayland.windowManager.hyprland.settings.monitor = lib.mkForce [
    "eDP-1,2560x1440@165,0x0,1.6"
    # "eDP-1, disable"
    # "HDMI-A-1,2560x1440@144,0x0,1.0"
  ];

  # since we are using this as a "desktop" of sorts, we have no need to save
  # power by using optimus. poor performance on external display, so we add
  # this line to force hyprland to use the nvidia GPU only for rendering. can
  # be removed if only using internal display
  # wayland.windowManager.hyprland.settings.env = [
  #   "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0"
  # ];

  # programs.waybar.settings.mainBar.output = "HDMI-A-1";
  programs.waybar.settings.mainBar.output = "eDP-1";

  # liminalOS.desktop.hyprland.screenlocker.monitor = "HDMI-A-1";
  liminalOS.desktop.hyprland.screenlocker.monitor = "eDP-1";
}
