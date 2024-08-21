{
  pkgs,
  inputs,
  system,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.stablepkgs.legacyPackages.${system}.hyprland;
    settings = {
      exec-once = ["waypaper --restore"];
      "$mod" = "SUPER";
      "$Left" = "Y";
      "$Right" = "O";
      "$Up" = "I";
      "$Down" = "U";
      env = [
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,26"
        "XCURSOR_THEME,Bibata-Modern-Ice"
        "XCURSOR_SIZE,26"
      ];
      bind = [
        # Application Keybinds
        "$mod, F, exec, librewolf"
        "$mod, T, exec, kitty"
        "$mod, E, exec, dolphin"
        "$mod, R, exec, pavucontrol"

        # Window actions
        "$mod, Q, killactive"
        "$mod, W, togglefloating"
        "$mod, J, togglesplit"
        "$mod, Return, fullscreen"

        # Move around
        "$mod, $Left, movefocus, l"
        "$mod, $Right, movefocus, r"
        "$mod, $Up, movefocus, u"
        "$mod, $Down, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod, S, togglespecialworkspace"

        # Move windows around
        "$mod+Shift+Ctrl, $Left, movewindow, l"
        "$mod+Shift+Ctrl, $Right, movewindow, r"
        "$mod+Shift+Ctrl, $Up, movewindow, u"
        "$mod+Shift+Ctrl, $Down, movewindow, d"

        "$mod+Ctrl+Alt, $Right, movetoworkspace, r+1"
        "$mod+Ctrl+Alt, $Left, movetoworkspace, r-1"

        "$mod+Ctrl, $Right, workspace, r+1"
        "$mod+Ctrl, $Left, workspace, r-1"

        "$mod+Alt, S, movetoworkspacesilent, special"

        # Utilities
        "$mod, Space, exec, pkill -x rofi || rofi -show drun" # Run rofi

        ''$mod, P, exec, grim -g "$(slurp)" - | swappy -f -'' # Screenshot

        "$mod, Backspace, exec, wlogout" # show logout menu

        "$mod, L, exec, hyprlock"

        # System control
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86AudioRaiseVolume, exec, pamixer -i 5"
        ",XF86AudioLowerVolume, exec, pamixer -d 5"
        ",XF86AudioMute, exec, pamixer -t"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod, Z, movewindow"
        "$mod, X, resizewindow"
      ];
      windowrulev2 = [
        "opacity 0.90 0.90,class:^(librewolf)$"
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
        "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
        "opacity 0.80 0.80,class:^(org.kde.ark)$"
        "opacity 0.80 0.80,class:^(nwg-look)$"
        "opacity 0.80 0.80,class:^(qt5ct)$"
        "opacity 0.80 0.80,class:^(qt6ct)$"
        "opacity 0.80 0.80,class:^(kvantummanager)$"

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
        "float,class:^(vlc)$"
        "float,class:^(kvantummanager)$"
        "float,class:^(qt5ct)$"
        "float,class:^(qt6ct)$"
        "float,class:^(nwg-look)$"
        "float,class:^(org.kde.ark)$"
        "float,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
        "float,class:^(app.drey.Warp)$ # Warp-Gtk"
        "float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
        "float,class:^(yad)$ # Protontricks-Gtk"
        "float,class:^(eog)$ # Imageviewer-Gtk"
        "float,class:^(io.github.alainm23.planify)$ # planify-Gtk"
        "float,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
        "float,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk"
        "float,class:^(pavucontrol)$"
        "float,class:^(blueman-manager)$"
        "float,class:^(nm-applet)$"
        "float,class:^(nm-connection-editor)$"
        "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
        "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"
      ];
      layerrule = [
        "blur,rofi"
        "ignorezero,rofi"
        "blur,notifications"
        "ignorezero,notifications"
        "blur,swaync-notification-window"
        "ignorezero,swaync-notification-window"
        "blur,swaync-control-center"
        "ignorezero,swaync-control-center"
        "blur,logout_dialog"
      ];
      monitor = ["DP-1,2560x1440@165,1920x0,auto" "HDMI-A-1,1920x1080@60,0x0,1"];
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
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      general = {
        gaps_in = "3";
        gaps_out = "8";
        border_size = "2";
        #
        # the dot is a hyprland name, not nix syntax, so we escape it
        "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
        "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
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
        drop_shadow = "false";
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
        sensitivity = "0.5";
      };
    };
  };

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
      lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
      before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
      after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
    };
  };

  xdg.portal = {
    enable = true;
    configPackages = [pkgs.xdg-desktop-portal-hyprland];
    extraPortals = [pkgs.xdg-desktop-portal-hyprland];
  };
}
