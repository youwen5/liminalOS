{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.liminalOS.desktop.hyprland;
  hyprnome = "${lib.getExe pkgs.hyprnome}";
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    bind =
      [
        "$mod+Shift, $Left, scroller:movewindow, l"
        "$mod+Shift, $Right, scroller:movewindow, r"
        "$mod+Shift, $Up, scroller:movewindow, u"
        "$mod+Shift, $Down, scroller:movewindow, d"

        # Move around
        "$mod, $Left, scroller:movefocus, l"
        "$mod, $Right, scroller:movefocus, r"
        "$mod, $Up, scroller:movefocus, u"
        "$mod, $Down, scroller:movefocus, d"
        "$mod, comma, scroller:admitwindow"
        "$mod, period, scroller:expelwindow"
        "$mod, F, scroller:fitsize, active"
        "$mod, Y, scroller:fitsize, all"
        "$mod, semicolon, scroller:cyclesize, next"
        "$mod, apostrophe, scroller:cyclesize, previous"

        "$mod+Shift, U, exec, ${hyprnome} --move"
        "$mod+Shift, I, exec, ${hyprnome} --previous --move"

        "$mod, U, exec, ${hyprnome}"
        "$mod, I, exec, ${hyprnome} --previous"

        "$mod, C, scroller:setmode, c"
        "$mod, V, scroller:setmode, r"

        "$mod, G, scroller:jump"
        "$mod+Ctrl, G, scroller:toggleoverview"
        # Window actions
        "$mod, Q, killactive"
        "$mod, W, togglefloating"
        "$mod, Return, fullscreen"

        # Utilities
        "$mod, Space, exec, pkill -x rofi || rofi -show drun" # Run rofi application launcher
        "$mod, X, exec, pkill -x rofi || rofi -show window" # Run rofi window switcher

        "$mod, Backspace, exec, pkill -x wlogout || wlogout" # show logout menu

        "$mod, Z, exec, loginctl lock-session"

        # Media controls
        ",XF86AudioMute, exec, ${lib.getExe pkgs.pamixer} -t"
        ",XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} --player=%any,firefox play-pause"
        ",XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} --player=%any,firefox next"
        ",XF86AudioRewind, exec, ${lib.getExe pkgs.playerctl} --player=%any,firefox previous"

        "$mod, S, togglespecialworkspace"
        "$mod+Alt, S, movetoworkspacesilent, special"
        "$mod, Tab, workspace, previous"
        ''$mod+Shift, P, exec, ${lib.getExe pkgs.grim} - | ${lib.getExe pkgs.swappy} -f -'' # Screenshot full screen
        ''$mod, P, exec, ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe pkgs.swappy} -f -'' # Screenshot

        # browser
        "$mod, B, exec, ${lib.getExe config.liminalOS.programs.defaultBrowser}"
      ]
      ++ (lib.optionals config.liminalOS.desktop.swaync.enable [
        "$mod, N, exec, sleep 0.1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
      ])
      ++ (lib.optionals config.liminalOS.programs.enable [
        # Application Keybinds
        "$mod, R, exec, ${lib.getExe pkgs.pavucontrol} -t 3" # open pavucontrol on 'outputs' tab
        "$mod, T, exec, ${lib.getExe pkgs.kitty}"
        "$mod, E, exec, ${lib.getExe pkgs.nautilus}"
        "$mod, M, exec, ${lib.getExe pkgs.thunderbird}"
      ]);

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
    bindel = [
      ",XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} set 5%-"
      ",XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} set 5%+"
      ",XF86AudioRaiseVolume, exec, ${lib.getExe pkgs.pamixer} -i 5"
      ",XF86AudioLowerVolume, exec, ${lib.getExe pkgs.pamixer} -d 5"
    ];
    binde = [
      # Resize windows
      "$mod+Alt, $Right, resizeactive, 30 0"
      "$mod+Alt, $Left, resizeactive, -30 0"
      "$mod+Alt, $Up, resizeactive, 0 -30"
      "$mod+Alt, $Down, resizeactive, 0 30"
    ];
  };
}
