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
    neofetch

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    fzf # A command-line fuzzy finder
    bat # replacement for cat
    delta # git pager
    lazygit # git TUI

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # system tools
    pciutils # lspci
    usbutils # lsusb

    # desktop utils
    wl-clipboard
    rofi-wayland
    grim
    slurp
    swappy
    pavucontrol
    swww
    waypaper

    # desktop apps
    dolphin
    bitwarden-desktop
    thunderbird
    spotify
    vesktop
    signal-desktop

    # dev tools
    nodePackages_latest.pnpm
    rustfmt
    rust-analyzer

    # desktop ricing
    bibata-cursors
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    papirus-icon-theme
    libsForQt5.qt5ct

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

  services.easyeffects.enable = true;

  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
  };

  programs.wlogout.enable = true;

  wayland.windowManager.hyprland = import ./modules/desktop/hyprland.nix;

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

  programs.waybar = import ./modules/desktop/waybar/waybar.nix;

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

    # zimfw = {
    #   enable = true;
    #   disableVersionCheck = true;
    #   degit = true;
    #   zmodules = [
    #     "environment"
    #     "git"
    #     "input"
    #     "termtitle"
    #     "utility"
    #     "exa"
    #     "fzf"
    #     "magic-enter"
    #   ];
    # };
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

  programs.fd.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      vim_keys = true;
      theme_background = false;
    };
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
