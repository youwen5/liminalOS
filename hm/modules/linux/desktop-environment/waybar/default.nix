{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.functorOS.desktop.waybar;
  theme = config.lib.stylix;
  palette = theme.colors;
in
{
  options.functorOS.desktop.waybar = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.functorOS.desktop.enable;
      description = ''
        Whether to enable Waybar and the functorOS rice.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ playerctl ];
    programs.waybar =
      let
        isDesktop = osConfig.functorOS.formFactor == "desktop";
        isLaptop = osConfig.functorOS.formFactor == "laptop";
      in
      {
        enable = true;
        systemd.enable = true;
        systemd.target = lib.mkIf config.functorOS.desktop.hyprland.enable "hyprland-session.target";
        settings.mainBar = {
          name = "bar0";
          reload_style_on_change = true;
          position = "top";
          layer = "top";
          height = 37;
          margin-top = 8;
          margin-bottom = 0;
          margin-left = 8;
          margin-right = 8;
          modules-left = [
            "custom/launcher"
          ]
          ++ (lib.optionals isDesktop [
            "custom/playerctl#backward"
            "custom/playerctl#play"
            "custom/playerctl#forward"
          ])
          ++ [
            "idle_inhibitor"
          ]
          ++ (lib.optionals isLaptop [
            "hyprland/workspaces"
          ])
          ++ [
            "custom/playerlabel"
          ];
          modules-center = lib.mkIf isDesktop [
            "cava#left"
            "hyprland/workspaces"
            "cava#right"
          ];
          modules-right = [
            "tray"
            "battery"
            "pulseaudio"
            "network"
            "clock"
          ];
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = "󰛊 ";
              deactivated = "󰾫 ";
            };
          };
          clock = {
            format = " {:%a, %d %b, %I:%M %p}";
            tooltip = "true";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = " {:%d/%m}";
          };
          "hyprland/workspaces" = {
            disable-scroll = false;
            on-scroll-down = "${lib.getExe pkgs.hyprnome}";
            on-scroll-up = "${lib.getExe pkgs.hyprnome} --previous";
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              active = "";
              default = "";
              urgent = "";
              special = "󰠱";
            };
            sort-by-number = true;
          };
          "cava#left" = {
            framerate = 60;
            autosens = 1;
            bars = 18;
            lower_cutoff_freq = 50;
            higher_cutoff_freq = 10000;
            method = "pipewire";
            source = "auto";
            stereo = true;
            reverse = false;
            bar_delimiter = 0;
            monstercat = false;
            waves = false;
            input_delay = 2;
            format-icons = [
              "<span foreground='#${palette.base08}'>▁</span>"
              "<span foreground='#${palette.base08}'>▂</span>"
              "<span foreground='#${palette.base08}'>▃</span>"
              "<span foreground='#${palette.base08}'>▄</span>"
              "<span foreground='#${palette.base0A}'>▅</span>"
              "<span foreground='#${palette.base0A}'>▆</span>"
              "<span foreground='#${palette.base0A}'>▇</span>"
              "<span foreground='#${palette.base0A}'>█</span>"
            ];
          };
          "cava#right" = {
            framerate = 60;
            autosens = 1;
            bars = 18;
            lower_cutoff_freq = 50;
            higher_cutoff_freq = 10000;
            method = "pipewire";
            source = "auto";
            stereo = true;
            reverse = false;
            bar_delimiter = 0;
            monstercat = false;
            waves = false;
            input_delay = 2;
            format-icons = [
              "<span foreground='#${palette.base08}'>▁</span>"
              "<span foreground='#${palette.base08}'>▂</span>"
              "<span foreground='#${palette.base08}'>▃</span>"
              "<span foreground='#${palette.base08}'>▄</span>"
              "<span foreground='#${palette.base0A}'>▅</span>"
              "<span foreground='#${palette.base0A}'>▆</span>"
              "<span foreground='#${palette.base0A}'>▇</span>"
              "<span foreground='#${palette.base0A}'>█</span>"
            ];
          };
          "custom/playerctl#backward" = {
            format = "󰙣 ";
            on-click = "playerctl previous";
            on-scroll-up = "playerctl volume .05+";
            on-scroll-down = "playerctl volume .05-";
          };
          "custom/playerctl#play" = {
            format = "{icon}";
            return-type = "json";
            exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
            on-click = "playerctl play-pause";
            on-scroll-up = "playerctl volume .05+";
            on-scroll-down = "playerctl volume .05-";
            format-icons = {
              Playing = "<span>󰏥 </span>";
              Paused = "<span> </span>";
              Stopped = "<span> </span>";
            };
          };
          "custom/playerctl#forward" = {
            format = "󰙡 ";
            on-click = "playerctl next";
            on-scroll-up = "playerctl volume .05+";
            on-scroll-down = "playerctl volume .05-";
          };
          "custom/playerlabel" = {
            format = "<span>󰎈 {} 󰎈</span>";
            return-type = "json";
            max-length = 40;
            exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
            on-click = "";
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = " {capacity}% ";
            format-alt = "{icon} {time}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
          };

          memory = {
            format = "󰍛 {}%";
            format-alt = "󰍛 {used}/{total} GiB";
            interval = 5;
          };
          cpu = {
            format = "󰻠 {usage}%";
            format-alt = "󰻠 {avg_frequency} GHz";
            interval = 5;
          };
          network = {
            format-wifi = "  {signalStrength}%";
            format-ethernet = "󰈀 100% ";
            tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
            format-linked = "{ifname} (No IP)";
            format-disconnected = "󰖪 0% ";
          };
          tray = {
            icon-size = 20;
            spacing = 8;
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-muted = "󰝟";
            format-icons = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            scroll-step = 5;
            on-click = "${lib.getExe pkgs.pavucontrol}";
          };
          "custom/launcher" =
            let
              toggle-colorscheme = pkgs.writeShellScriptBin "toggle-colorscheme.sh" ''
                POLARITY_FILE="/etc/polarity"

                if [[ ! -f "$POLARITY_FILE" ]]; then
                  exit 0
                elif [[ ! -r "$POLARITY_FILE" ]]; then
                  echo "Error: Cannot read $POLARITY_FILE. Check permissions." >&2
                  exit 1
                fi

                current_scheme=$(cat "$POLARITY_FILE")
                if [[ $? -ne 0 ]]; then
                    echo "Error: Failed to read content from $POLARITY_FILE." >&2
                    exit 1
                fi

                current_scheme=$(echo "$current_scheme" | xargs)

                target_service=""
                case "$current_scheme" in
                  dawn)
                    target_service="colorscheme-dusk.service"
                    ;;
                  dusk)
                    target_service="colorscheme-dawn.service"
                    ;;
                  *)
                    echo "Error: Invalid content '$current_scheme' found in $POLARITY_FILE. Expected 'dawn' or 'dusk'." >&2
                    exit 1
                    ;;
                esac

                echo "Current scheme: '$current_scheme'. Attempting to start '$target_service'..."
                systemctl start "$target_service"

                if [[ $? -ne 0 ]]; then
                  echo "Error: Failed to execute 'systemctl start $target_service'. Check systemctl logs or permissions." >&2
                  exit 1
                else
                  echo "Command 'systemctl start $target_service' executed successfully."
                fi

                exit 0
              '';
            in
            {
              format = "";
              on-click = "pkill -9 rofi || rofi -show drun";
              on-click-right = "${lib.getExe toggle-colorscheme}";
              tooltip = "false";
            };
        };
        style =
          let
            mkRgba =
              opacity: color:
              let
                c = config.lib.stylix.colors;
                r = c."${color}-rgb-r";
                g = c."${color}-rgb-g";
                b = c."${color}-rgb-b";
              in
              "rgba(${r}, ${g}, ${b}, ${opacity})";
          in
          ''
            * {
              border: none;
              border-radius: 0px;
              font-family: GeistMono Nerd Font;
              font-size: 13px;
              min-height: 0;
            }
            window#waybar {
              background: transparent;
              opacity: 0.9;
              border-radius: 24px;
            }

            #waybar > box {
              background: ${mkRgba "0.6" "base01"};
              border-radius: 24px;
            }

            #cava.left, #cava.right {
                background: #${palette.base00};
                margin: 4px;
                padding: 6px 16px;
                color: #${palette.base00};
            }
            #cava.left {
                border-radius: 16px;
                border-color: #${palette.base03};
                border-style: solid;
                border-width: 2px;
            }
            #cava.right {
                border-radius: 16px;
                border-color: #${palette.base03};
                border-style: solid;
                border-width: 2px;
            }
            #workspaces {
                background: #${palette.base00};
                color: #${palette.base00}
            }
            #workspaces button {
                padding: 0px 5px;
                margin: 0px 3px;
                border-radius: 16px;
                color: transparent;
                background: #${palette.base03};
                transition: all 0.3s ease-in-out;
            }

            #workspaces button.active {
                background-color: #${palette.base0A};
                color: #${palette.base03};
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
                transition: all 0.3s ease-in-out;
            }

            #workspaces button:hover {
                background-color: #${palette.base05};
                color: #${palette.base05};
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
            }

            #tray, #pulseaudio, #network, #battery,
            #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward{
                background: #${palette.base00};
                font-weight: bold;
                margin: 4px 0px;
            }
            #tray, #pulseaudio, #network, #battery{
                color: #${palette.base05};
                border-radius: 16px;
                border-color: #${palette.base03};
                border-style: solid;
                border-width: 2px;
                padding: 0 20px;
                margin-left: 7px;
            }
            #clock {
                color: #${palette.base05};
                background: #${palette.base00};
                border-radius: 18px 12px 12px 18px;
                padding: 8px 25px 8px 25px;
                margin-left: 7px;
                font-weight: bold;
                font-size: 14px;
            }
            #custom-launcher {
                color: #${palette.base0A};
                background: #${palette.base00};
                border-radius: 12px 18px 18px 12px;
                margin: 0px;
                padding: 0px 35px 0px 25px;
                font-size: 24px;
            }

            #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.forward {
                background: #${palette.base00};
                font-size: 20px;
            }
            #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.forward:hover{
                color: #${palette.base00};
            }
            #custom-playerctl.backward {
                color: #${palette.base08};
                border-radius: 16px 0px 0px 16px;
                border-color: #${palette.base03} #${palette.base00} #${palette.base03} #${palette.base03};
                border-style: solid;
                border-width: 2px 0px 2px 2px;
                padding-left: 16px;
                margin-left: 7px;
            }
            #custom-playerctl.play {
                color: #${palette.base0A};
                padding: 0 5px;
                border-color: #${palette.base03} #${palette.base00} #${palette.base03} #${palette.base00};
                border-style: solid;
                border-width: 2px 0px 2px 0px;
            }
            #custom-playerctl.forward {
                color: #${palette.base08};
                border-radius: 0px 16px 16px 0px;
                border-color: #${palette.base03} #${palette.base03} #${palette.base03} #${palette.base00};
                border-style: solid;
                border-width: 2px 2px 2px 0px;
                padding-right: 12px;
                margin-right: 7px
            }
            #custom-playerlabel {
                background: #${palette.base00};
                color: #${palette.base05};
                padding: 0 20px;
                border-radius: 16px;
                border-color: #${palette.base03};
                border-style: solid;
                border-width: 2px;
                margin: 4px 0;
                font-weight: bold;
            }
            #idle_inhibitor {
                background: #${palette.base00};
                color: #${palette.base05};
                padding: 0 10px 0 15px;
                border-radius: 16px;
                border-color: #${palette.base03};
                border-style: solid;
                border-width: 2px;
                margin: 4px 7px 4px 0;
                font-weight: bold;
            }
            #window{
                background: #${palette.base00};
                padding-left: 15px;
                padding-right: 15px;
                border-radius: 16px;
                margin-top: 4px;
                margin-bottom: 4px;
                font-weight: normal;
                font-style: normal;
            }
          ''
          + (lib.optionalString isLaptop ''
            #workspaces {
              margin: 4px;
              padding: 6px 16px;
              border-radius: 16px;
              border-color: #${palette.base03};
              border-style: solid;
              border-width: 2px;
            }
          '')
          + (lib.optionalString isDesktop ''
            #workspaces {
              margin: 4px 5px;
              padding: 6px 5px;
              border-radius: 16px;
              border-width: 2px;
              border-color: #${palette.base03};
              border-style: solid;
            }
          '');
      };
  };
}
