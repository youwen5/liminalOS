{
  inputs,
  system,
  ...
}: {
  wayland.windowManager.hyprland.settings.monitor = ["DP-1,2560x1440@165,1920x0,auto" "HDMI-A-1,1920x1080@60,0x0,1"];
  wayland.windowManager.hyprland.package = inputs.stablepkgs.legacyPackages.${system}.hyprland;
}
