{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    wl-clipboard
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-icon-theme
    libsForQt5.qt5ct
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        # "${pkgs.waypaper}/bin/waypaper --restore"
        "[workspace 2 silent] ${pkgs.kitty}/bin/kitty"
      ];
      "$mod" = "SUPER";
      "$Left" = "H";
      "$Right" = "L";
      "$Up" = "K";
      "$Down" = "J";
      # env = [
      #   "HYPRCURSOR_THEME,Bibata-Modern-Ice"
      #   "HYPRCURSOR_SIZE,26"
      #   "XCURSOR_THEME,Bibata-Modern-Ice"
      #   "XCURSOR_SIZE,26"
      # ];
      bind = [
        # Application Keybinds
        "$mod, T, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "$mod, R, exec, ${pkgs.pavucontrol}/bin/pavucontrol -t 3" # open pavucontrol on 'outputs' tab
        "$mod, M, exec, ${pkgs.thunderbird}/bin/thunderbird"
        # "$mod, B, exec, ${pkgs.waypaper}/bin/waypaper"
        "$mod, A, exec, ${pkgs.neovide}/bin/neovide"
        "$mod, N, exec, sleep 0.1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"

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

        "$mod, Z, exec, hyprlock"

        # Media controls
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox play-pause"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox next"
        ",XF86AudioRewind, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox previous"
        "$mod, F, exec, zen"
      ];
      # ++ (
      #   if pkgs.system != "aarch64-linux" then [ "$mod, F, exec, zen" ] else [ "$mod, F, exec, floorp" ]
      # );
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
      windowrulev2 = [
        "opacity 0.90 0.90,class:^(librewolf)$"
        "opacity 0.90 0.90,class:^(floorp)$"
        "opacity 0.90 0.90,class:^(zen-alpha)$"
        "opacity 0.90 0.90,class:^(Brave-browser)$"
        "opacity 0.80 0.80,class:^(Steam)$"
        "opacity 0.80 0.80,class:^(steam)$"
        "opacity 0.80 0.80,class:^(steamwebhelper)$"
        "opacity 0.80 0.80,class:^(Spotify)$"
        "opacity 0.80 0.80,initialTitle:^(Spotify Premium)$"
        "opacity 0.80 0.80,initialTitle:^(Spotify Free)$"
        "opacity 0.80 0.80,class:^(code-oss)$"
        "opacity 0.80 0.80,class:^(Code)$"
        "opacity 0.80 0.80,class:^(code-url-handler)$"
        "opacity 0.80 0.80,class:^(code-insiders-url-handler)$"
        "opacity 0.80 0.80,class:^(kitty)$"
        "opacity 0.80 0.80,class:^(neovide)$"
        "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
        "opacity 0.80 0.80,class:^(thunar)$"
        "opacity 0.80 0.80,class:^(org.kde.ark)$"
        "opacity 0.80 0.80,class:^(nwg-look)$"
        "opacity 0.80 0.80,class:^(qt5ct)$"
        "opacity 0.80 0.80,class:^(qt6ct)$"
        "opacity 0.80 0.80,class:^(kvantummanager)$"
        "opacity 0.80 0.80,class:^(waypaper)$"
        "opacity 0.80 0.80,class:^(org.pulseaudio.pavucontrol)$"
        "opacity 0.80 0.80,class:^(thunderbird)$"

        "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
        "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk"
        "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$ # Cartridges-Gtk"
        "opacity 0.80 0.80,class:^(com.obsproject.Studio)$ # Obs-Qt"
        "opacity 0.80 0.80,class:^(gnome-boxes)$ # Boxes-Gtk"
        "opacity 0.80 0.80,class:^(discord)$ # Discord-Electron"
        "opacity 0.80 0.80,class:^(vesktop)$ # Vesktop-Electron"
        "opacity 0.80 0.80,class:^(ArmCord)$ # ArmCord-Electron"
        "opacity 0.80 0.80,class:^(app.drey.Warp)$ # Warp-Gtk"
        "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
        "opacity 0.80 0.80,class:^(yad)$ # Protontricks-Gtk"
        "opacity 0.80 0.80,class:^(signal)$ # Signal-Gtk"
        "opacity 0.80 0.80,class:^(io.github.alainm23.planify)$ # planify-Gtk"
        "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
        "opacity 0.80 0.80,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk"
        "opacity 0.80 0.80,class:^(lutris)$ # Lutris game launcher"

        "opacity 0.80 0.70,class:^(pavucontrol)$"
        "opacity 0.80 0.70,class:^(blueman-manager)$"
        "opacity 0.80 0.70,class:^(nm-applet)$"
        "opacity 0.80 0.70,class:^(nm-connection-editor)$"
        "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"

        "float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$"
        "float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$"
        "float,title:^(Picture-in-Picture)$"
        "float,class:^(librewolf)$,title:^(Library)$"
        "float,class:^(floorp)$,title:^(Library)$"
        "float,class:^(zen-alpha)$,title:^(Library)$"
        "float,title:^(Extension: (Bitwarden Password Manager))$"
        "float,class:^(vlc)$"
        "float,class:^(kvantummanager)$"
        "float,class:^(qt5ct)$"
        "float,class:^(qt6ct)$"
        "float,class:^(nwg-look)$"
        "float,class:^(org.kde.ark)$"
        "float,class:^(org.pulseaudio.pavucontrol)$"
        "float,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
        "float,class:^(app.drey.Warp)$ # Warp-Gtk"
        "float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
        "float,class:^(yad)$ # Protontricks-Gtk"
        "float,class:^(eog)$ # Imageviewer-Gtk"
        "float,class:^(io.github.alainm23.planify)$ # planify-Gtk"
        "float,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
        "float,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-applet)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
        "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"

        "size 50% 50%,class:^(org.pulseaudio.pavucontrol)"

        "stayfocused, class:^(pinentry-)" # fix pinentry losing focus
      ];
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
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          # "border, 1, 1, liner"
          # "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
          # "layers, 1, 8, default, slide"
        ];
      };

      general = {
        gaps_in = "3";
        gaps_out = "8";
        border_size = "2";
        #
        # the dot is a hyprland name, not nix syntax, so we escape it
        "col.active_border" = pkgs.lib.mkForce "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = pkgs.lib.mkForce "rgba(b4befecc) rgba(6c7086cc) 45deg";
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

      shadow = {
        enabled = false;
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
      };
      input = {
        sensitivity = "-0.65";
      };
    };
  };

  services.hyprpaper.enable = true;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 1;
      };
      background = {
        monitor = "";
        path = "screenshot";
        blur_passes = 3;
        blur_size = 7;
        noise = 1.17e-2;
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

  services.hypridle = {
    enable = true;
    settings = {
      lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock"; # avoid starting multiple hyprlock instances.
      before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
      after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
    };
  };
}
