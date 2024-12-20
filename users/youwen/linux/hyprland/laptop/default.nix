{ lib, ... }:
{
  imports = [ ../common.nix ];
  wayland.windowManager.hyprland.settings.input.touchpad = {
    natural_scroll = true;
    disable_while_typing = true;
    clickfinger_behavior = true;
    tap-to-click = false;
    scroll_factor = 0.15;
  };
  wayland.windowManager.hyprland.settings.input.sensitivity = lib.mkForce "0.0";
  wayland.windowManager.hyprland.settings.env = [
    "HYPRCURSOR_THEME,Bibata-Modern-Ice"
    "HYPRCURSOR_SIZE,24"
    "XCURSOR_THEME,Bibata-Modern-Ice"
    "XCURSOR_SIZE,24"
  ];
}
