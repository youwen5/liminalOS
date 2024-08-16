{pkgs, ...}: {
  wayland.windowManager.hyprland.settings.monitor = pkgs.lib.mkForce ["eDP-1,2560x1440@165,0x0,1.6"];
}
