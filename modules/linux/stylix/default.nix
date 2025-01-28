{
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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to uniformly theme the entire system using Stylix.
      '';
    };
    plymouth.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable plymouth and sane defaults.
      '';
    };
    wallpaper = lib.mkOption {
      type = lib.types.anything;
      default = "../../../hm/modules/common/shellenv/fastfetch/nixos-logo.png";
      description = ''
        Path to wallpaper to set as background and generate system colorscehme from.
      '';
    };
    polarity = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "light"
          "dark"
        ]
      );
      default = null;
      description = ''
        Whether to force colorscheme to be generated as light or dark theme. Set to null to automatically determine.
      '';
    };
    base16Scheme = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Base 16 colorscheme from base16-schemes to override wallpaper generated colorscheme with. Set to null to use wallpaper generated scheme.
        Example: ''${pkgs.base16-schemes}/share/themes/rose-pine.yaml
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      image = lib.mkIf (cfg.wallpaper != null) cfg.wallpaper;
      base16Scheme = lib.mkIf (cfg.base16Scheme != null) cfg.base16Scheme;
      polarity = lib.mkIf (cfg.polarity != null) cfg.polarity;

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
        size = if config.liminalOS.formFactor == "laptop" then 24 else 26;
      };
    };

    boot = {
      plymouth = {
        enable = true;
        font = "${config.stylix.fonts.monospace.package}/share/fonts/truetype/NerdFonts/CaskaydiaCove/CaskaydiaCoveNerdFontMono-Regular.ttf";
      };

      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      initrd.systemd.enable = true;
    };

  };
}
