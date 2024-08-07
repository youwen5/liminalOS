{ pkgs, ... }: {
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
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "gruvbox-dark";
  };
}
