{
  pkgs,
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.liminalOS.desktop.waybar;
  theme = config.lib.stylix;
  palette = theme.colors;
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
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ playerctl ];
    programs.waybar =
      let
        isDesktop = osConfig.liminalOS.formFactor == "desktop";
        isLaptop = osConfig.liminalOS.formFactor == "laptop";
      in
      {
        enable = true;
        systemd.enable = true;
        systemd.target = lib.mkIf config.liminalOS.desktop.hyprland.enable "hyprland-session.target";
        settings.mainBar = {
          name = "bar0";
          reload_style_on_change = true;
          position = "top";
          layer = "top";
          height = 37;
          margin-top = 0;
          margin-bottom = 0;
          margin-left = 0;
          margin-right = 0;
          modules-left =
            [
              "custom/launcher"
            ]
            ++ (lib.optionals isDesktop [

              "custom/playerctl#backward"
              "custom/playerctl#play"
              "custom/playerctl#foward"
            ])
            ++ [
              "custom/playerlabel"
            ]
            ++ (lib.optionals isLaptop [
              "hyprland/workspaces"
            ]);
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
          clock = {
            format = " {:%a, %d %b, %I:%M %p}";
            tooltip = "true";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
            format-alt = " {:%d/%m}";
          };
          "hyprland/workspaces" = {
            disable-scroll = false;
            on-scroll-down = "${pkgs.hyprnome}/bin/hyprnome";
            on-scroll-up = "${pkgs.hyprnome}/bin/hyprnome --previous";
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
          "custom/playerctl#foward" = {
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
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
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
              on-click-right = "${toggle-colorscheme}/bin/toggle-colorscheme.sh";
              tooltip = "false";
            };
        };
        style =
          ''
            * {
              border: none;
              border-radius: 0px;
              font-family: GeistMono Nerd Font;
              font-size: 13px;
              min-height: 0;
            }
            window#waybar {
              background: #${palette.base01};
            }

            #cava.left, #cava.right {
                background: #${palette.base00};
                margin: 4px;
                padding: 6px 16px;
                color: #${palette.base00};
            }
            #cava.left {
                border-radius: 24px 10px 24px 10px;
            }
            #cava.right {
                border-radius: 10px 24px 10px 24px;
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
                background: #${palette.base01};
                transition: all 0.3s ease-in-out;
            }

            #workspaces button.active {
                background-color: #${palette.base0A};
                color: #${palette.base01};
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
                transition: all 0.3s ease-in-out;
            }

            #workspaces button:hover {
                background-color: #${palette.base05};
                color: #${palette.base01};
                border-radius: 16px;
                min-width: 50px;
                background-size: 400% 400%;
            }

            #tray, #pulseaudio, #network, #battery,
            #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward{
                background: #${palette.base00};
                font-weight: bold;
                margin: 4px 0px;
            }
            #tray, #pulseaudio, #network, #battery{
                color: #${palette.base05};
                border-radius: 10px 24px 10px 24px;
                padding: 0 20px;
                margin-left: 7px;
            }
            #clock {
                color: #${palette.base05};
                background: #${palette.base00};
                border-radius: 0px 0px 0px 40px;
                padding: 8px 10px 8px 25px;
                margin-left: 7px;
                font-weight: bold;
                font-size: 14px;
            }
            #custom-launcher {
                color: #${palette.base0A};
                background: #${palette.base00};
                border-radius: 0px 0px 40px 0px;
                margin: 0px;
                padding: 0px 35px 0px 15px;
                font-size: 24px;
            }

            #custom-playerctl.backward, #custom-playerctl.play, #custom-playerctl.foward {
                background: #${palette.base00};
                font-size: 20px;
            }
            #custom-playerctl.backward:hover, #custom-playerctl.play:hover, #custom-playerctl.foward:hover{
                color: #${palette.base05};
            }
            #custom-playerctl.backward {
                color: #${palette.base08};
                border-radius: 24px 0px 0px 10px;
                padding-left: 16px;
                margin-left: 7px;
            }
            #custom-playerctl.play {
                color: #${palette.base0A};
                padding: 0 5px;
            }
            #custom-playerctl.foward {
                color: #${palette.base08};
                border-radius: 0px 10px 24px 0px;
                padding-right: 12px;
                margin-right: 7px
            }
            #custom-playerlabel {
                background: #${palette.base00};
                color: #${palette.base05};
                padding: 0 20px;
                border-radius: 24px 10px 24px 10px;
                margin: 4px 0;
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
              border-radius: 24px 10px 24px 10px;
            }
          '')
          + (lib.optionalString isDesktop ''
            #workspaces {
              margin: 4px 5px;
              padding: 6px 5px;
              border-radius: 16px;
            }
          '');
      };
  };
}
