{ pkgs, ...}:
{
  wayland.windowManager.hyprland = import ./hyprland-conf.nix;

  # Audio effects and EQ tool
  services.easyeffects.enable = true;
  services.easyeffects.package = pkgs.easyeffects;

  # Notification daemon
  services.dunst = {
    enable = true;
    catppuccin.enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "32x32";
    };
  };

  # Currently non-functional
  programs.wlogout.enable = true;

  gtk = {
    enable = true;
    catppuccin.enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    iconTheme = { name = "Papirus-Dark"; };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source =
      "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "gruvbox-dark";
  };

  programs.waybar = import ./waybar/waybar-conf.nix;
}
