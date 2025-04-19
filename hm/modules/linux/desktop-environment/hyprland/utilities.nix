{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.desktop.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    systemd.user.services = lib.mkIf cfg.bluelight.enable {
      hyprsunset = {
        Unit = {
          Description = "Start the hyprsunset daemon";
          PartOf = "hyprland-session.target";
          After = "hyprland-session.target";
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset";
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install = {
          WantedBy = [ "hyprland-session.target" ];
        };
      };
    };

    services.hyprpaper.enable = true;

    programs.wlogout.enable = true;

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
          mkRgba =
            opacity: color:
            let
              c = config.lib.stylix.colors;
              r = c."${color}-rgb-r";
              g = c."${color}-rgb-g";
              b = c."${color}-rgb-b";
            in
            mkLiteral "rgba ( ${r}, ${g}, ${b}, ${opacity} % )";
          mkRgb = mkRgba "100";
          rofiOpacity = builtins.toString (builtins.ceil (config.stylix.opacity.popups * 100));
        in
        {
          "*" = {
            font = "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";
            text-color = mkRgb "base05";
            background-color = mkRgba rofiOpacity "base00";
          };
          "window" = {
            height = mkLiteral "20em";
            width = mkLiteral "30em";
            border-radius = mkLiteral "8px";
            border-width = mkLiteral "2px";
            padding = mkLiteral "1.5em";
          };
          "mainbox" = {
            background-color = mkRgba rofiOpacity "base01";
          };
          "inputbar" = {
            margin = mkLiteral "0 0 1em 0";
          };
          "prompt" = {
            enabled = false;
          };
          "entry" = {
            placeholder = "Search...";
            padding = mkLiteral "1em 1em";
            text-color = mkRgb "base05";
            background-color = mkRgba rofiOpacity "base00";
            border-radius = mkLiteral "8px";
          };
          "element-text" = {
            padding = mkLiteral "0.5em 1em";
            margin = mkLiteral "0 0.5em";
          };
          "element-icon" = {
            size = mkLiteral "3ch";
          };
          "element-text selected" = {
            background-color = mkRgba rofiOpacity "base0A";
            text-color = mkRgb "base01";
            border-radius = mkLiteral "8px";
          };
        };
    };

    services.swayosd.enable = true;

    programs.hyprlock = lib.mkIf cfg.screenlocker.enable {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          grace = 0;
        };
        background = {
          monitor = cfg.screenlocker.monitor;
          path =
            if cfg.screenlocker.useCrashFix then "/tmp/__hyprlock-monitor-screenshot.png" else "screenshot";
          blur_passes = 3;
          blur_size = 7;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        };
        input-field = {
          monitor = "";
          size = "200, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = false;
          dots_rounding = -1;
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Input Password...</i>";
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 34, 34)";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 2000;
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;

          position = "0, -20";
          halign = "center";
          valign = "center";
        };
      };
    };

    services.hypridle = lib.mkIf cfg.idleDaemon.enable {
      enable = true;
      settings = {
        general = {
          lock_cmd =
            if cfg.screenlocker.useCrashFix then
              "pidof hyprlock || ${pkgs.grim}/bin/grim -o ${config.programs.hyprlock.settings.background.monitor} /tmp/__hyprlock-monitor-screenshot.png && ${pkgs.hyprlock}/bin/hyprlock"
            else
              "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };
        listener = [
          {
            timeout = 1500;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330; # 5.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
