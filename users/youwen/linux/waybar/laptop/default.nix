{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        # width = 1000;
        reload-style-on-change = true;
        margin = "5px 0px 0px 0px";
        modules-left = ["hyprland/window" "hyprland/workspaces" "network" "clock"];
        modules-right = ["group/hardware" "backlight" "group/adjustable" "custom/weather"];
        # modules-center = [ "network" "group/hardware" "clock" ];
        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          format = "{icon}";
          persistent-workspaces = {
            eDP-1 = [1];
            DP-1 = [2 3 4 5];
          };
        };
        "group/hardware" = {
          orientation = "inherit";
          modules = ["cpu" "battery"];
        };
        "group/adjustable" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
          modules = ["pulseaudio" "mpris"];
        };
        "custom/weather" = {
          orientation = "horizontal";
          exec = ''curl wttr.in/?format="%l:%20%t"'';
          interval = 10;
        };
        cpu = {
          interval = 10;
          format = "{usage}%  ";
        };
        memory = {
          interval = 10;
          format = "{percentage}%  ";
        };
        # mpris = {
        #   format-playing = "    {title}  ";
        #   format-paused = " 󰏤 {title}  ";
        #   format-stopped = "Nothing Playing";
        # };
        tray = {spacing = 10;};
        clock = {format = "{:%a %b %d, %I:%M %p} ";};
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = ["󰃞" "󰃠"];
        };
        battery = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-icons = ["󰁻" "󰁽" "󰁿" "󰂀" "󰁹"];
        };
        "hyprland/window" = {format = "{class}";};
        network = {
          format-wifi = "{essid} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{volume}% {icon}  {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {default = ["" "" ""];};
        };
      };
    };
    style = ./waybar.css;
    systemd.enable = true;
  };
}
