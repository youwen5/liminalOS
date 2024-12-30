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
  options.liminalOS.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.desktop.enable;
      description = ''
        Whether to enable and rice Hyprland as well as some basic desktop utilities.
      '';
    };
    applyGtkFix = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
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
      default = cfg.enable;
      description = ''
        Whether to set up Hyprlock for screen locking.
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
      settings = {
        "$mod" = "SUPER";
        "$Left" = "H";
        "$Right" = "L";
        "$Up" = "K";
        "$Down" = "J";
        env =
          (lib.optionals cfg.applyGtkFix [
            "GSK_RENDERER,gl"
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
        bind =
          [
            # Window actions
            "$mod, Q, killactive"
            "$mod, W, togglefloating"
            "$mod, V, togglesplit"
            "$mod, Return, fullscreen"

            # Move around
            "$mod, $Left, movefocus, l"
            "$mod, $Right, movefocus, r"
            "$mod, $Up, movefocus, u"
            "$mod, $Down, movefocus, d"

            "$mod, D, workspace, previous"

            "$mod, 1, workspace, 1"
            "$mod+Ctrl, H, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod+Ctrl, J, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod+Ctrl, K, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod+Ctrl, L, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod+Ctrl, semicolon, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod+Ctrl, apostrophe, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod+Ctrl, U, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod+Ctrl, I, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod+Ctrl, O, workspace, 9"
            "$mod, 0, workspace, 10"
            "$mod+Ctrl, P, workspace, 10"

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            "$mod+Shift, 1, movetoworkspace, 1"
            "$mod+Ctrl+Shift, H, movetoworkspace, 1"
            "$mod+Shift, 2, movetoworkspace, 2"
            "$mod+Ctrl+Shift, J, movetoworkspace, 2"
            "$mod+Shift, 3, movetoworkspace, 3"
            "$mod+Ctrl+Shift, K, movetoworkspace, 3"
            "$mod+Shift, 4, movetoworkspace, 4"
            "$mod+Ctrl+Shift, L, movetoworkspace, 4"
            "$mod+Shift, 5, movetoworkspace, 5"
            "$mod+Ctrl+Shift, semicolon, movetoworkspace, 5"
            "$mod+Shift, 6, movetoworkspace, 6"
            "$mod+Ctrl+Shift, apostrophe, movetoworkspace, 6"
            "$mod+Shift, 7, movetoworkspace, 7"
            "$mod+Ctrl+Shift, U, movetoworkspace, 7"
            "$mod+Shift, 8, movetoworkspace, 8"
            "$mod+Ctrl+Shift, I, movetoworkspace, 8"
            "$mod+Shift, 9, movetoworkspace, 9"
            "$mod+Ctrl+Shift, O, movetoworkspace, 9"
            "$mod+Shift, 0, movetoworkspace, 10"
            "$mod+Ctrl+Shift, P, movetoworkspace, 10"

            # Special workspace
            "$mod, S, togglespecialworkspace"
            "$mod+Alt, S, movetoworkspacesilent, special"

            # Move windows around
            "$mod+Shift, $Left, movewindow, l"
            "$mod+Shift, $Right, movewindow, r"
            "$mod+Shift, $Up, movewindow, u"
            "$mod+Shift, $Down, movewindow, d"

            "$mod+Ctrl, bracketright, movetoworkspace, r+1"
            "$mod+Ctrl, bracketleft, movetoworkspace, r-1"

            "$mod, bracketright, workspace, r+1"
            "$mod, bracketleft, workspace, r-1"

            # Utilities
            "$mod, Space, exec, pkill -x rofi || rofi -show drun" # Run rofi application launcher
            "$mod, G, exec, pkill -x rofi || rofi -show window" # Run rofi window switcher

            ''$mod, P, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot
            ''$mod+Shift, P, exec, ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot

            "$mod, Backspace, exec, pkill -x wlogout || wlogout" # show logout menu

            "$mod, Z, exec, loginctl lock-session"

            # Media controls
            ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
            ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox play-pause"
            ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox next"
            ",XF86AudioRewind, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox previous"
          ]
          ++ (lib.optionals config.liminalOS.programs.zen.enable [
            "$mod, F, exec, zen"
          ])
          ++ (lib.optionals config.liminalOS.desktop.swaync.enable [
            "$mod, N, exec, sleep 0.1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
          ])
          ++ (lib.optionals config.liminalOS.programs.enable [
            # Application Keybinds
            "$mod, R, exec, ${pkgs.pavucontrol}/bin/pavucontrol -t 3" # open pavucontrol on 'outputs' tab
            "$mod, T, exec, ${pkgs.kitty}/bin/kitty"
            "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
            "$mod, M, exec, ${pkgs.thunderbird}/bin/thunderbird"
          ]);
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        bindel = [
          ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
          ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%+"
          ",XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
          ",XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        ];
        binde = [
          # Resize windows
          "$mod+Alt, $Right, resizeactive, 30 0"
          "$mod+Alt, $Left, resizeactive, -30 0"
          "$mod+Alt, $Up, resizeactive, 0 -30"
          "$mod+Alt, $Down, resizeactive, 0 30"
        ];
        windowrulev2 = import ./windowrulev2.nix;
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
          ];
          animation =
            [
              "windows, 1, 6, wind, slide"
              "windowsIn, 1, 6, winIn, slide"
              "windowsOut, 1, 5, winOut, slide"
              "windowsMove, 1, 5, wind, slide"
              "fade, 1, 10, default"
              "workspaces, 1, 5, wind"
              # "layers, 1, 8, default, slide"
            ]
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
            layout = "dwindle";
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

    services.hyprpaper.enable = true;

    programs.wlogout.enable = true;

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      # theme = "gruvbox-dark";
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = {
        modi = "window,drun,ssh,combi,filebrowser,recursivebrowser";
        display-drun = " 󰘧 ";
        combi-modi = "window,drun,ssh";
        run-shell-command = "{terminal} -e {cmd}";
        sidebar-mode = true;
        background-color = "transparent";
        sorting = "fuzzy";
      };
    };

    programs.hyprlock = lib.mkIf cfg.screenlocker.enable {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          grace = 1;
        };
        background = {
          monitor = "";
          path = "/tmp/__hyprlock-monitor-screenshot.png";
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
          lock_cmd = "pidof hyprlock || ${pkgs.grim}/bin/grim -o ${config.programs.hyprlock.settings.background.monitor} /tmp/__hyprlock-monitor-screenshot.png && ${pkgs.hyprlock}/bin/hyprlock"; # avoid starting multiple hyprlock instances.
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
