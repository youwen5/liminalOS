{
  services.skhd = {
    enable = true;
    config = ''
      # opens iTerm2
      alt - return : kitty
      
      # Navigation
      alt - y : yabai -m window --focus west
      alt - u : yabai -m window --focus south
      alt - i : yabai -m window --focus north
      alt - o : yabai -m window --focus east
      
      # Moving windows
      shift + alt - y : yabai -m window --warp west
      shift + alt - u : yabai -m window --warp south
      shift + alt - i : yabai -m window --warp north
      shift + alt - o : yabai -m window --warp east
      
      # Move focus container to workspace
      shift + alt - m : yabai -m window --space last; yabai -m space --focus last
      shift + alt - p : yabai -m window --space prev; yabai -m space --focus prev
      shift + alt - n : yabai -m window --space next; yabai -m space --focus next
      shift + alt - 1 : yabai -m window --space 1; yabai -m space --focus 1
      shift + alt - 2 : yabai -m window --space 2; yabai -m space --focus 2
      shift + alt - 3 : yabai -m window --space 3; yabai -m space --focus 3
      shift + alt - 4 : yabai -m window --space 4; yabai -m space --focus 4
      
      # Resize windows
      lctrl + alt - y : yabai -m window --resize left:-50:0; \
                        yabai -m window --resize right:-50:0
      lctrl + alt - u : yabai -m window --resize bottom:0:50; \
                        yabai -m window --resize top:0:50
      lctrl + alt - i : yabai -m window --resize top:0:-50; \
                        yabai -m window --resize bottom:0:-50
      lctrl + alt - o : yabai -m window --resize right:50:0; \
                        yabai -m window --resize left:50:0
      
      # Equalize size of windows
      lctrl + alt - e : yabai -m space --balance
      
      # Enable / Disable gaps in current workspace
      lctrl + alt - g : yabai -m space --toggle padding; yabai -m space --toggle gap
      
      # Rotate windows clockwise and anticlockwise
      alt - r         : yabai -m space --rotate 270
      shift + alt - r : yabai -m space --rotate 90
      
      # Rotate on X and Y Axis
      shift + alt - x : yabai -m space --mirror x-axis
      shift + alt - y : yabai -m space --mirror y-axis
      
      # Set insertion point for focused container
      shift + lctrl + alt - h : yabai -m window --insert west
      shift + lctrl + alt - j : yabai -m window --insert south
      shift + lctrl + alt - k : yabai -m window --insert north
      shift + lctrl + alt - l : yabai -m window --insert east
      
      # Float / Unfloat window
      shift + alt - space : \
          yabai -m window --toggle float; \
          yabai -m window --toggle border
      
      # Make window native fullscreen
      alt - f         : yabai -m window --toggle zoom-fullscreen
      shift + alt - f : yabai -m window --toggle native-fullscreen
    '';
  };
}
