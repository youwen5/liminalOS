{ lib, ... }:
{
  imports = [
    ../../users/youwen/hm.nix
  ];

  home.stateVersion = "24.05";

  liminalOS.desktop.hyprland.screenlocker.monitor = "eDP-1";
  liminalOS.desktop.hyprland.screenlocker.useCrashFix = true;

  # explicit sync must be disabled for honeykrisp to load
  wayland.windowManager.hyprland.settings.render.explicit_sync = 0;
}
