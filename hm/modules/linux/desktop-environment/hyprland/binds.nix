{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.liminalOS.desktop.hyprland;
in
{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    bind =
      (
        if cfg.hyprscroller.enable then
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
          ]
        else
          # Move windows around
          [
            "$mod+Shift, $Left, movewindow, l"
            "$mod+Shift, $Right, movewindow, r"
            "$mod+Shift, $Up, movewindow, u"
            "$mod+Shift, $Down, movewindow, d"

            # Move around
            "$mod, $Left, movefocus, l"
            "$mod, $Right, movefocus, r"
            "$mod, $Up, movefocus, u"
            "$mod, $Down, movefocus, d"

            "$mod, V, togglesplit"
          ]
      )
      ++ (lib.optionals cfg.hyprscroller.enable [
        "$mod, comma, scroller:admitwindow"
        "$mod, period, scroller:expelwindow"
        "$mod, F, scroller:fitsize, active"
        "$mod, Y, scroller:fitsize, all"
        "$mod, semicolon, scroller:cyclesize, next"
        "$mod, apostrophe, scroller:cyclesize, previous"

        "$mod+Shift, U, movetoworkspace, r+1"
        "$mod+Shift, I, movetoworkspace, r-1"

        "$mod, U, workspace, r+1"
        "$mod, I, workspace, r-1"

        # harder to reach number keys
        "$mod, A, workspace, 1"
        "$mod, D, workspace, 2"

        "$mod, C, scroller:setmode, c"
        "$mod, V, scroller:setmode, r"

        "$mod, G, scroller:jump"
        "$mod+Ctrl, G, scroller:toggleoverview"
      ])
      ++ [
        # Window actions
        "$mod, Q, killactive"
        "$mod, W, togglefloating"
        "$mod, Return, fullscreen"

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

        "$mod+Ctrl, bracketright, movetoworkspace, r+1"
        "$mod+Ctrl, bracketleft, movetoworkspace, r-1"

        "$mod, bracketright, workspace, r+1"
        "$mod, bracketleft, workspace, r-1"

        # Utilities
        "$mod, Space, exec, pkill -x rofi || rofi -show drun" # Run rofi application launcher
        "$mod, X, exec, pkill -x rofi || rofi -show window" # Run rofi window switcher

        ''$mod+Shift, P, exec, ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot

        "$mod, Backspace, exec, pkill -x wlogout || wlogout" # show logout menu

        "$mod, Z, exec, loginctl lock-session"

        # Media controls
        ",XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
        ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox play-pause"
        ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox next"
        ",XF86AudioRewind, exec, ${pkgs.playerctl}/bin/playerctl --player=%any,firefox previous"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod+Shift, 1, movetoworkspace, 1"
        "$mod+Shift, 2, movetoworkspace, 2"
        "$mod+Shift, 3, movetoworkspace, 3"
        "$mod+Shift, 4, movetoworkspace, 4"
        "$mod+Shift, 5, movetoworkspace, 5"
        "$mod+Shift, 6, movetoworkspace, 6"
        "$mod+Shift, 7, movetoworkspace, 7"
        "$mod+Shift, 8, movetoworkspace, 8"
        "$mod+Shift, 9, movetoworkspace, 9"
        "$mod+Shift, 0, movetoworkspace, 10"
      ]
      ++ (lib.optionals (!cfg.useAdvancedBindings) [
        "$mod, S, togglespecialworkspace"
        "$mod+Alt, S, movetoworkspacesilent, special"
        "$mod, Tab, workspace, previous"
        ''$mod, P, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot
      ])
      ++ (lib.optionals cfg.useAdvancedBindings [
        # Special workspace
        "$mod, C, togglespecialworkspace"
        "$mod+Alt, C, movetoworkspacesilent, special"

        ''$mod, semicolon, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -'' # Screenshot

        "$mod, a, workspace, 1"
        "$mod, s, workspace, 2"
        "$mod, d, workspace, 3"
        "$mod, f, workspace, 4"
        "$mod, g, workspace, 5"
        "$mod, y, workspace, 6"
        "$mod, u, workspace, 7"
        "$mod, i, workspace, 8"
        "$mod, o, workspace, 9"
        "$mod, p, workspace, 10"

        "$mod+Shift, a, movetoworkspace, 1"
        "$mod+Shift, s, movetoworkspace, 2"
        "$mod+Shift, d, movetoworkspace, 3"
        "$mod+Shift, f, movetoworkspace, 4"
        "$mod+Shift, g, movetoworkspace, 5"
        "$mod+Shift, y, movetoworkspace, 6"
        "$mod+Shift, u, movetoworkspace, 7"
        "$mod+Shift, i, movetoworkspace, 8"
        "$mod+Shift, o, movetoworkspace, 9"
        "$mod+Shift, p, movetoworkspace, 10"
      ])
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
  };
}
