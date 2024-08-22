{pkgs, ...}: {
  wayland.windowManager.hyprland.package = pkgs.lib.mkForce pkgs.hyprland;
  home.file.".config/neofetch/config.conf".source = ./neofetch-asahi.conf;
}
