{ osConfig, lib, ... }:
{
  config.stylix.targets = lib.mkIf osConfig.liminalOS.theming.enable {
    waybar.enable = false;
    kitty.variant256Colors = true;
    neovim.enable = false;
    kde.enable = true;
    gnome.enable = true;
    swaync.enable = false;
    hyprlock.enable = false;
    hyprland.enable = false;
  };
}
