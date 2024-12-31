{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  programs.hyprlock.settings.background.monitor = lib.mkForce "eDP-1";
}
