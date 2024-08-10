{ config, pkgs, ... }:

{
  home.username = "youwen";
  home.homeDirectory = "/home/youwen";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  home.file.".config/neofetch/config.conf".source = ../common/neofetch.conf;
  home.file.".wallpapers" = {
    source = ../../../wallpapers;
    recursive = true;
  };

  home.file.".config/easyeffects/input" = {
    source = ./easyeffects/input;
    recursive = true;
  };

  home.file.".config/easyeffects/output" = {
    source = ./easyeffects/output;
    recursive = true;
  };
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.

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

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
