{ config, pkgs, ... }:

{
  home.username = "youwen";
  home.homeDirectory = "/home/youwen";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    dolphin
    bitwarden-desktop
    thunderbird
    spotify

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    bat
    pavucontrol

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    hugo # static site generator
    glow # markdown previewer in terminal

    btop # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring
    fd

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    wl-clipboard
    rofi-wayland
    grim
    slurp
    swappy

    # messaging apps
    vesktop
    signal-desktop

    nodePackages_latest.pnpm
    rustfmt
    rust-analyzer

    zoxide

    # ricing
    swww
    waypaper
    bibata-cursors
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-icon-theme
    libsForQt5.qt5ct

    delta
    lazygit
  ];

  services.dunst = {
    enable = true;
    catppuccin.enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "32x32";
    };
  };

  services.easyeffects = { enable = true; };

  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.wlogout = { enable = true; };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    exec-once = [ "waybar" "waypaper --restore" ];
    "$mod" = "SUPER";
    "$Left" = "Y";
    "$Right" = "O";
    "$Up" = "I";
    "$Down" = "U";
    env = [
      "HYPRCURSOR_THEME,Bibata-Modern-Ice"
      "HYPRCURSOR_SIZE,26"
      "XCURSOR_THEME,Bibata-Modern-Ice"
      "XCURSOR_SIZE,26"
    ];
    bind = [
      # Application Keybinds
      "$mod, F, exec, librewolf"
      "$mod, T, exec, kitty"
      "$mod, E, exec, dolphin"
      "$mod, R, exec, pavucontrol"

      # Window actions
      "$mod, Q, killactive"
      "$mod, W, togglefloating"
      "$mod, J, togglesplit"
      "$mod, Return, fullscreen"

      # Move around
      "$mod, $Left, movefocus, l"
      "$mod, $Right, movefocus, r"
      "$mod, $Up, movefocus, u"
      "$mod, $Down, movefocus, d"

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

      "$mod, S, togglespecialworkspace"

      # Move windows around
      "$mod+Shift+Ctrl, $Left, movewindow, l"
      "$mod+Shift+Ctrl, $Right, movewindow, r"
      "$mod+Shift+Ctrl, $Up, movewindow, u"
      "$mod+Shift+Ctrl, $Down, movewindow, d"

      "$mod+Ctrl+Alt, $Right, movetoworkspace, r+1"
      "$mod+Ctrl+Alt, $Left, movetoworkspace, r-1"

      "$mod+Ctrl, $Right, workspace, r+1"
      "$mod+Ctrl, $Left, workspace, r-1"

      "$mod+Alt, S, movetoworkspacesilent, special"

      # Utilities
      "$mod, Space, exec, pkill -x rofi || rofi -show drun" # Run rofi

      ''$mod, P, exec, grim -g "$(slurp)" - | swappy -f -'' # Screenshot

      "$mod, Backspace, exec, wlogout" # Screenshot
    ];
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod, Z, movewindow"
      "$mod, X, resizewindow"
    ];
    windowrulev2 = [
      "opacity 0.90 0.90,class:^(librewolf)$"
      "opacity 0.90 0.90,class:^(Brave-browser)$"
      "opacity 0.80 0.80,class:^(Steam)$"
      "opacity 0.80 0.80,class:^(steam)$"
      "opacity 0.80 0.80,class:^(steamwebhelper)$"
      "opacity 0.80 0.80,class:^(Spotify)$"
      "opacity 0.80 0.80,initialTitle:^(Spotify Free)$"
      "opacity 0.80 0.80,class:^(code-oss)$"
      "opacity 0.80 0.80,class:^(Code)$"
      "opacity 0.80 0.80,class:^(code-url-handler)$"
      "opacity 0.80 0.80,class:^(code-insiders-url-handler)$"
      "opacity 0.80 0.80,class:^(kitty)$"
      "opacity 0.80 0.80,class:^(org.kde.dolphin)$"
      "opacity 0.80 0.80,class:^(org.kde.ark)$"
      "opacity 0.80 0.80,class:^(nwg-look)$"
      "opacity 0.80 0.80,class:^(qt5ct)$"
      "opacity 0.80 0.80,class:^(qt6ct)$"
      "opacity 0.80 0.80,class:^(kvantummanager)$"

      "opacity 0.90 0.90,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
      "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$ # Flatseal-Gtk"
      "opacity 0.80 0.80,class:^(hu.kramo.Cartridges)$ # Cartridges-Gtk"
      "opacity 0.80 0.80,class:^(com.obsproject.Studio)$ # Obs-Qt"
      "opacity 0.80 0.80,class:^(gnome-boxes)$ # Boxes-Gtk"
      "opacity 0.80 0.80,class:^(discord)$ # Discord-Electron"
      "opacity 0.80 0.80,class:^(vesktop)$ # Vesktop-Electron"
      "opacity 0.80 0.80,class:^(ArmCord)$ # ArmCord-Electron"
      "opacity 0.80 0.80,class:^(app.drey.Warp)$ # Warp-Gtk"
      "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
      "opacity 0.80 0.80,class:^(yad)$ # Protontricks-Gtk"
      "opacity 0.80 0.80,class:^(Signal)$ # Signal-Gtk"
      "opacity 0.80 0.80,class:^(io.github.alainm23.planify)$ # planify-Gtk"
      "opacity 0.80 0.80,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
      "opacity 0.80 0.80,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gtk"

      "opacity 0.80 0.70,class:^(pavucontrol)$"
      "opacity 0.80 0.70,class:^(blueman-manager)$"
      "opacity 0.80 0.70,class:^(nm-applet)$"
      "opacity 0.80 0.70,class:^(nm-connection-editor)$"
      "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"

      "float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$"
      "float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$"
      "float,title:^(Picture-in-Picture)$"
      "float,class:^(librewolf)$,title:^(Library)$"
      "float,class:^(vlc)$"
      "float,class:^(kvantummanager)$"
      "float,class:^(qt5ct)$"
      "float,class:^(qt6ct)$"
      "float,class:^(nwg-look)$"
      "float,class:^(org.kde.ark)$"
      "float,class:^(com.github.rafostar.Clapper)$ # Clapper-Gtk"
      "float,class:^(app.drey.Warp)$ # Warp-Gtk"
      "float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
      "float,class:^(yad)$ # Protontricks-Gtk"
      "float,class:^(eog)$ # Imageviewer-Gtk"
      "float,class:^(io.github.alainm23.planify)$ # planify-Gtk"
      "float,class:^(io.gitlab.theevilskeleton.Upscaler)$ # Upscaler-Gtk"
      "float,class:^(com.github.unrud.VideoDownloader)$ # VideoDownloader-Gkk"
      "float,class:^(pavucontrol)$"
      "float,class:^(blueman-manager)$"
      "float,class:^(nm-applet)$"
      "float,class:^(nm-connection-editor)$"
      "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
      "opacity 0.80 0.80,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"
    ];
    layerrule = [
      "blur,rofi"
      "ignorezero,rofi"
      "blur,notifications"
      "ignorezero,notifications"
      "blur,swaync-notification-window"
      "ignorezero,swaync-notification-window"
      "blur,swaync-control-center"
      "ignorezero,swaync-control-center"
      "blur,logout_dialog"
    ];
    monitor =
      [ "DP-1,2560x1440@165,1920x0,auto" "HDMI-A-1,1920x1080@60,0x0,1" ];
    dwindle = {
      pseudotile = "yes";
      preserve_split = "yes";
    };
    animations = {
      enabled = "yes";
      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];
      animation = [
        "windows, 1, 6, wind, slide"
        "windowsIn, 1, 6, winIn, slide"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 1, 5, wind, slide"
        "border, 1, 1, liner"
        "borderangle, 1, 30, liner, loop"
        "fade, 1, 10, default"
        "workspaces, 1, 5, wind"
      ];
    };
    general = {
      gaps_in = "3";
      gaps_out = "8";
      border_size = "2";
      #
      # the dot is a hyprland name, not nix syntax, so we escape it
      "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
      "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
      layout = "dwindle";
      resize_on_border = "true";
      sensitivity = "0.5";
    };
    decoration = {
      rounding = "10";
      drop_shadow = "false";
      dim_special = "0.3";
      blur = {
        enabled = "yes";
        size = "6";
        passes = "3";
        new_optimizations = "on";
        ignore_opacity = "on";
        xray = "false";
        special = true;
      };
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Youwen Wu";
    userEmail = "youwenw@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgsign = "true";
      user.signingkey = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
    };
  };

  programs.lazygit.enable = true;

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font.name = "CaskaydiaCove Nerd Font";
    settings = {
      font_size = 12;
      window_padding_width = "8 8 0";
      confirm_os_window_close = -1;
      shell_integration = "enabled";
      enable_audio_bell = "no";
      background_opacity = "0.8";
    };
  };

  programs.readline = {
    enable = true;
    extraConfig = "set editing-mode vi";
  };

  gtk = {
    enable = true;
    catppuccin.enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    iconTheme = { name = "Papirus-Dark"; };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source =
      "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
        width = 1600;
        reload-style-on-change = true;
        margin = "10px 0px 0px 0px";
        modules-left = [ "hyprland/window" "hyprland/workspaces" ];
        modules-right = [ "backlight" "group/adjustable" "custom/weather" ];
        modules-center = [ "network" "group/hardware" "clock" ];
        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          format = "{icon}";
          persistent-workspaces = {
            eDP-1 = [ 1 ];
            DP-1 = [ 2 3 4 5 ];
          };
        };
        "group/hardware" = {
          orientation = "inherit";
          modules = [ "cpu" "memory" "battery" ];
        };
        "group/adjustable" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = true;
          };
          modules = [ "pulseaudio" "mpris" ];
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
        tray = { spacing = 10; };
        clock = { format = "{:%a %b %d, %I:%M %p} "; };
        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = [ "󰃞" "󰃠" ];
        };
        battery = {
          states = {
            good = 95;
            warning = 20;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-icons = [ "󰁻" "󰁽" "󰁿" "󰂀" "󰁹" ];
        };
        "hyprland/window" = { format = "{class}"; };
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
          format-icons = { default = [ "" "" "" ]; };
        };
      };
    };
    style = ./waybar/waybar.css;
  };

  programs.zoxide = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.github-copilot-cli ];
  };

  programs.oh-my-posh = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    useTheme = "catppuccin_macchiato";
  };

  programs.zsh = {
    enable = false;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza -l --icons=auto";
      update = "sudo nixos-rebuild switch";
    };
    defaultKeymap = "viins";

    zimfw = {
      enable = true;
      disableVersionCheck = true;
      degit = true;
      zmodules = [
        "environment"
        "git"
        "input"
        "termtitle"
        "utility"
        "exa"
        "fzf"
        "magic-enter"
      ];
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      ls = "eza -l --icons=auto";
    };
    interactiveShellInit = ''
      fish_vi_key_bindings
      set -g fish_greeting
    '';
    plugins = [
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          hash = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fetchFromGitHub {
          owner = "meaningful-ooo";
          repo = "sponge";
          rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
          hash = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
        };
      }
      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
          hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }
    ];
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.bash.enable = true;

  programs.librewolf = {
    enable = true;
    settings = {
      "webgl.disabled" = false;
      "privacy.resistFingerprinting" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "network.cookie.lifetimePolicy" = 0;
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
