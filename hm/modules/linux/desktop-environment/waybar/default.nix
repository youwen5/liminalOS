{
  pkgs,
  osConfig,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.desktop.waybar;
in
{
  options.liminalOS.desktop.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.desktop.enable;
      description = ''
        Whether to enable Waybar and the liminalOS rice.
      '';
    };
  };

  config = {
    programs.waybar = lib.mkIf cfg.enable {
      enable = true;
      style =
        let
          inherit (config.lib.stylix) colors;
        in
        ''
          window#waybar {
              font-family: ${config.stylix.fonts.monospace.name};
              background-color: rgba(0,0,0,0);
              font-size: 0.8rem;
              border-radius: 0.5rem;
              color: #${colors.base05};
          }

          .modules-left {
              opacity: 1;
              /* background: linear-gradient(45deg, #${colors.base0B}, #${colors.base0A}); */
              background: #${colors.base01};
              border-radius: 0.5rem;
              padding: 2px;
          }

          .modules-center {
              opacity: 0;
          }

          .modules-right {
              opacity: 1;
              background-color: #${colors.base00};
              border-radius: 0.5rem;
              padding: 2px 2px 2px 10px
          }

          /* label.module {
              margin-left: -1px;
          } */

          #workspaces {
              background-color: #${colors.base00};
              border-radius: 0.5rem;
              padding: 0 2px 0 2px;
          }

          #workspaces button {
              font-size: 0.75rem;
              padding: 0 0.2rem 0 0.2rem;
              border: #${colors.base05};
              color: #${colors.base05};
          }

          #window {
              background-color: #${colors.base00};
              border-radius: 0.5rem;
              padding: 2px 5px;
          }

          #clock {
              font-weight: bolder;
              border-radius: 0.5rem;
              padding: 0 3px 0 0;
          }

          #battery {
              color: #${colors.base08};
          }

          #memory {
              color: #${colors.base09};
          }

          #disk {
              color: #${colors.base0A};
          }

          #cpu {
              color: #${colors.base0B};
          }

          #temperature {
              color: #${colors.base0C};
          }

          #network {
              color: #${colors.base0D};
          }
        '';
      systemd.enable = true;
      settings = {
        mainBar = {
          name = "bar0";

          layer = "top";
          position = "top";

          height = 28;

          "margin" = "5px 10px 0px 10px";
          "spacing" = 10;

          # "mode" = "top";

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
            "custom/notification"
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

          "custom/notification" = lib.mkIf config.liminalOS.desktop.swaync.enable {
            tooltip = false;
            format = "{icon}";
            format-icons = {
              notification = "<span foreground='red'><small><sup>⬤</sup></small></span>";
              none = " ";
              dnd-notification = "<span foreground='red'><small><sup>⬤</sup></small></span>";
              dnd-none = " ";
            };
            return-type = "json";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
            on-click = "sleep 0.1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
            on-click-right = "sleep 0.1 && ${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
            escape = true;
          };

          "hyprland/workspaces" = {
            show-special = true;
            # persistent-workspaces = {
            #   "*" = [
            #     1
            #     2
            #     3
            #     4
            #     5
            #     6
            #     7
            #     8
            #     9
            #     10
            #   ];
            # };
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              "1" = "";
              "2" = "";
              "3" = "󰰊";
              "4" = "󰰍";
              "5" = "";
              "6" = "";
              "7" = "󰰨";
              "8" = "";
              "9" = "";
              "10" = "";
              active = "";
              empty = "";
              default = "";
              urgent = "";
              special = "󰠱";
            };
            sort-by-number = true;
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
  };
}
