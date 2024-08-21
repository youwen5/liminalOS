{pkgs, ...}: {
  wayland.windowManager.hyprland.package = pkgs.lib.mkForce pkgs.hyprland;
}
