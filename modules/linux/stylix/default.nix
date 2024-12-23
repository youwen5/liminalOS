{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.theming;
in
{
  options.liminalOS.theming = {
    enable = lib.mkEnableOption "theming";
  };

  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = "${inputs.wallpapers}/aesthetic/afterglow_city_skyline_at_night.png";
      # image = "${inputs.wallpapers}/aesthetic/red_deadly_sun.jpg";
      # image = "${inputs.wallpapers}/aesthetic/afterglow_sand_dunes.jpg";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      polarity = "dark";

      fonts = {
        serif = {
          name = "Noto Serif";
          package = pkgs.noto-fonts;
        };
        sansSerif = {
          name = "Noto Sans";
          package = pkgs.noto-fonts;
        };
        emoji = {
          name = "Noto Color Emoji";
          package = pkgs.noto-fonts-emoji;
        };
        monospace = {
          name = "CaskaydiaCove Nerd Font";
          package = pkgs.nerd-fonts.caskaydia-cove;
        };
      };

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 26;
      };
    };
  };
}
