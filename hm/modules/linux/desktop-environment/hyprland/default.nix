{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.liminalOS.desktop.hyprland;
in
{
  imports = [
    ./binds.nix
    ./utilities.nix
    ./windowrules.nix
  ];

  options.liminalOS.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.desktop.enable;
      description = ''
        Whether to enable and rice Hyprland as well as some basic desktop utilities.
      '';
    };
    hyprscroller.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable the hyprscroller scrolling layout.
      '';
    };
    useAdvancedBindings = lib.mkEnableOption "advanced keybinds";
    gtkUseOpenGL = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to set GSK_RENDERER environment variable to stop GTK apps from crashing.
      '';
    };
    idleDaemon.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to setup and enable Hypridle with some defaults to automatically lock the screen and suspend after idling.
      '';
    };
    screenlocker.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable && cfg.idleDaemon.enable;
      description = ''
        Whether to set up Hyprlock for screen locking.
      '';
    };
    screenlocker.useNvidiaCrashFix = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.liminalOS.system.graphics.nvidia.enable;
      description = ''
        Whether to use a workaround for Hyprlock background blur not working on Nvidia-based machines. Before locking, a screenshot will be taken and placed at `/tmp/__hyprlock-monitor-screenshot.png`.
      '';
    };
    screenlocker.monitor = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Monitor to use for screen locker. Use `hyprctl monitors` to determine.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        wl-clipboard
        libsForQt5.qtstyleplugin-kvantum
        libsForQt5.qt5ct
        papirus-icon-theme
        libsForQt5.qt5ct
        hyprland-qtutils
      ]
      ++ (lib.optionals (!osConfig.liminalOS.theming.enable) [
        pkgs.bibata-cursors
      ]);

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = lib.mkIf cfg.hyprscroller.enable [
        (pkgs.hyprlandPlugins.hyprscroller.overrideAttrs {
          version = "0.47.2";
          src = pkgs.fetchFromGitHub {
            owner = "dawsers";
            repo = "hyprscroller";
            rev = "ce7503685297d88e0bb0961343ed3fbed21c559c";
            hash = "sha256-3pGIe4H1LUOJw0ULfVwZ7Ph7r/AyEipx7jbWP7zz3MU=";
          };
        })
      ];
      settings = {
        "$mod" = "SUPER";
        "$Left" = "H";
        "$Right" = "L";
        "$Up" = "K";
        "$Down" = "J";
        env =
          (lib.optionals cfg.gtkUseOpenGL [
            "GSK_RENDERER,ngl"
          ])
          ++ (lib.optionals (config.liminalOS.formFactor == "laptop" && !osConfig.liminalOS.theming.enable) [
            "HYPRCURSOR_THEME,Bibata-Modern-Ice"
            "HYPRCURSOR_SIZE,24"
            "XCURSOR_THEME,Bibata-Modern-Ice"
            "XCURSOR_SIZE,24"
          ])
          ++ (lib.optionals (config.liminalOS.formFactor == "desktop" && !osConfig.liminalOS.theming.enable) [
            "HYPRCURSOR_THEME,Bibata-Modern-Ice"
            "HYPRCURSOR_SIZE,26"
            "XCURSOR_THEME,Bibata-Modern-Ice"
            "XCURSOR_SIZE,26"
          ]);
        layerrule = [
          "blur,rofi"
          "ignorezero,rofi"
          "animation slide bottom 0.2 0.2 wind,rofi"
          "blur,notifications"
          "ignorezero,notifications"
          "blur,swaync-notification-window"
          "animation slide right 0.5 0.5,swaync-control-center"
          "animation slide right 0.5 0.5,notifications"
          "animation slide right 0.5 0.5,swaync-notification-window"
          "ignorezero,swaync-notification-window"
          "blur,swaync-control-center"
          "ignorezero,swaync-control-center"
          "blur,logout_dialog"
        ];
        dwindle = {
          pseudotile = "yes";
          preserve_split = "yes";
        };
        animations = {
          enabled = "yes";
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
            "windup, 0.05, 0.9, 0.1, 1.05"
          ];
          animation =
            [
              "windows, 1, 6, wind, slide"
              "windowsIn, 1, 6, winIn, slide"
              "windowsOut, 1, 5, winOut, slide"
              "windowsMove, 1, 5, wind, slide"
              "fade, 1, 10, default"
              # "layers, 1, 8, default, slide"
            ]
            ++ (
              if cfg.hyprscroller.enable then
                [
                  "workspaces, 1, 5, wind, slidevert"
                ]
              else
                [
                  "workspaces, 1, 5, wind"
                ]
            )
            ++ (lib.optionals (!osConfig.liminalOS.powersave) [
              "border, 1, 1, liner"
              "borderangle, 1, 30, liner, loop"
            ]);
        };

        general =
          let
            inherit (config.lib.stylix) colors;
          in
          {
            gaps_in = "3";
            gaps_out = "8";
            border_size = "2";
            # "col.active_border" = pkgs.lib.mkForce "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
            # "col.inactive_border" = pkgs.lib.mkForce "rgba(b4befecc) rgba(6c7086cc) 45deg";
            "col.active_border" = "rgba(${colors.base0A}ff) rgba(${colors.base09}ff) 45deg";
            "col.inactive_border" = "rgba(${colors.base01}cc) rgba(${colors.base02}cc) 45deg";
            layout = if cfg.hyprscroller.enable then "scroller" else "dwindle";
            resize_on_border = "true";
          };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };

        cursor = {
          hide_on_key_press = true;
        };

        decoration = {
          rounding = "10";
          dim_special = "0.3";
          blur = {
            enabled = "yes";
            size = "6";
            passes = "3";
            new_optimizations = "on";
            ignore_opacity = "on";
            xray = "false";
            special = true;
          };
          shadow = {
            enabled = false;
          };
        };
        input = {
          sensitivity = if config.liminalOS.formFactor == "laptop" then "0.0" else "-0.65";
        };
        plugin.scroller = lib.mkIf cfg.hyprscroller.enable {
          column_widths = "onethird onehalf twothirds one";
          column_heights = "onethird onehalf twothirds one";
        };
      };
    };

    wayland.windowManager.hyprland.settings.input.touchpad =
      lib.mkIf (config.liminalOS.formFactor == "laptop")
        {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          tap-to-click = false;
          scroll_factor = 0.15;
        };

    assertions = [
      {
        assertion =
          !cfg.screenlocker.useNvidiaCrashFix
          || (cfg.screenlocker.useNvidiaCrashFix && cfg.screenlocker.monitor != null);
        message = "To use the Nvidia crash fix, you must set screenlocker.monitor to the monitor you want to use as the lock screen that blurs! Use `hyprctl monitors` to determine the monitor codes (should be something like DP-1, HDMI-A-1, etc).";
      }
    ];
  };
}
