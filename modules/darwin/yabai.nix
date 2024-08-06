{ config, pkgs, ... }: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "on";
      window_placement = "second_child";
      window_opacity = "off";
      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      window_gap = 10;
      split_ratio = 0.50;
      split_type = "auto";
      layout = "bsp";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
  };
  services.skhd = { enable = true; };
  services.jankyborders = {
    enable = true;
    hidpi = true;
    inactive_color = "gradient(top_right=0x9992B3F5,bottom_left=0x9992B3F5)";
    blur_radius = 5.0;
  };
}

