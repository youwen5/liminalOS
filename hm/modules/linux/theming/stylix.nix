{ osConfig, lib, ... }:
{
  config = lib.mkIf osConfig.liminalOS.theming.enable {
    stylix.targets = {
      waybar.enable = false;
      kitty.variant256Colors = true;
      neovim.enable = false;
      kde.enable = true;
      gnome.enable = true;
      swaync.enable = false;
      hyprlock.enable = false;
      hyprland.enable = false;
      starship.enable = false;
      rofi.enable = false;
      mako.enable = false;
    };
  };
}
