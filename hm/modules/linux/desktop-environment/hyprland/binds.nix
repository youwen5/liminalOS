{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.liminalOS.desktop.hyprland;
  hyprnome = "${pkgs.hyprnome}/bin/hyprnome";
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
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox play-pause"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox next"
        ",XF86AudioRewind, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox previous"

        "$mod, S, togglespecialworkspace"
        "$mod+Alt, S, movetoworkspacesilent, special"
        "$mod, Tab, workspace, previous"
        ''$mod+Shift, P, exec, ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot full screen
        ''$mod, P, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot
      ]
      ++ (lib.optionals config.liminalOS.programs.zen.enable [
        "$mod, B, exec, zen"
      ])
      ++ (lib.optionals config.liminalOS.desktop.swaync.enable [
        "$mod, N, exec, sleep 0.1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw"
      ])
      ++ (lib.optionals config.liminalOS.programs.enable [
        # Application Keybinds
        "$mod, R, exec, ${pkgs.pavucontrol}/bin/pavucontrol -t 3" # open pavucontrol on 'outputs' tab
        "$mod, T, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, E, exec, ${lib.getExe pkgs.nautilus}"
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
  };
}
