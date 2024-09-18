{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd.enable = true;
    settings = {
      mainBar = {
        name = "bar0";

        layer = "top";
        position = "top";

        height = 28;
        # "width" = 1920;

        "margin" = "5px 10px 0px 10px";
        "spacing" = 10;

        "mode" = "top";
        # "exclusive" = true;

        # "output" = "eDP-1";

        reload_style_on_change = true;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "idle_inhibitor"
          "backlight"
          "wireplumber"
          "network"
          "battery"
          "disk"
          "memory"
          "cpu"
          "temperature"
          "clock"
        ];

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰛊 ";
            deactivated = "󰾫 ";
          };
        };

        network = {
          format = "{ifname}";
          format-wifi = "{icon}{essid}";
          format-ethernet = " {essid}";
          format-disconnected = "󰤯 Disconnected";
          format-icons = [
            "󰤟 "
            "󰤢 "
            "󰤨 "
          ];
          tooltip-format = "  {bandwidthUpBits} |   {bandwidthDownBits}";
          tooltip-format-wifi = "   {bandwidthUpBits} |    {bandwidthDownBits} | 󱄙   {signalStrength}";
        };

        backlight = {
          interval = 2;
          format = "󰖨 {percent}%";
          on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set +4";
          on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 4-";
        };

        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰝟 ";
          on-click = "pamixer -t";
          on-scroll-up = "${pkgs.pamixer}/bin/pamixer set 5%+";
          on-scroll-down = "${pkgs.pamixer}/bin/pamixer set 5%-";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
        };

        battery = {
          interval = 10;
          format = "{icon} {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip = true;
          tooltip-format = "{timeTo}";
        };

        disk = {
          intervel = 30;
          format = "󰋊 {percentage_used}%";
          tooltip-format = "{used} used out of {total} on \"{path}\" ({percentage_used}%)";
        };

        memory = {
          interval = 10;
          format = " {used}";
          tooltip-format = "{used}GiB used of {total}GiB ({percentage}%)";
        };

        cpu = {
          interval = 10;
          format = " {usage}%";
        };

        temperature = {
          interval = 10;
        };

        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
        };

        "hyprland/workspaces" = {
          show-special = true;
          persistent-workspaces = {
            "*" = [
              1
              2
              3
              4
              5
              6
              7
              8
              9
              10
            ];
          };
          format = "{icon}";
          format-icons = {
            active = "";
            empty = "";
            default = "";
            urgent = "";
            special = "󰠱";
          };
        };
        "hyprland/window" = {
          icon = true;
          icon-size = 20;
          max-length = 50;
          rewrite = {
            "(.*) — LibreWolf" = "$1";
            "(.*) — Zen Browser" = "$1";
            "^$" = "👾";
          };
        };
      };
    };
  };
}
