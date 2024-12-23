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
    stylixName = lib.mkOption {
      type = lib.types.str;
      default = "stylix";
      description = ''
        Name of Stylix module defined in `inputs`. Defaults to `stylix`. You must define `inputs.stylix.url` in your `flake.nix` to enable this option
      '';
    };
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
    assertions = [
      {
        assertion = builtins.hasAttr cfg.stylixName inputs;
        message = ''You enabled theming but did not add a Stylix module to your flake inputs, or did not set `liminalOS.theming.stylixName` to the name of your Stylix input, if it is not `stylix`. Please set `inputs.stylix.url = "github:danth/stylix"` or set the stylixName option to the name of your stylix flake input.'';
      }
    ];
  };
}
