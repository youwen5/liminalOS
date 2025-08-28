{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.functorOS.programs;
in
{
  imports = [
    ./bulk-programs.nix
  ];

  options.functorOS.programs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to set up many default desktop programs.
      '';
    };
    defaultBrowser = lib.mkOption {
      type = lib.types.package;
      default = pkgs.zen-browser;
      description = ''
        Default browser for the system.
      '';
    };
    browserDesktopFile = lib.mkOption {
      type = lib.types.str;
      default = "zen.desktop";
      description = ''
        Name of desktop file of browser.
      '';
    };
    terminal.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to set up kitty terminal.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.kitty = lib.mkIf cfg.terminal.enable {
      enable = true;
      font.name = "CaskaydiaCove Nerd Font";
      shellIntegration.enableFishIntegration = true;
      shellIntegration.enableBashIntegration = true;
      settings = {
        font_size = 11;
        window_padding_width = "8 8";
        confirm_os_window_close = -1;
        enable_audio_bell = "no";
        background_opacity = pkgs.lib.mkForce "0.8";
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty";
        scrollback_pager = ''nvim --noplugin -c "set signcolumn=no showtabline=0" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
        cursor = pkgs.lib.mkForce "#c0caf5";
        cursor_text_color = lib.mkForce "#1a1b26";
        cursor_trail = 3;
      };
      keybindings = {
        "kitty_mod+h" = "show_scrollback";
      };
    };

    programs.spotify-player.enable = true;

    programs.neovide = {
      enable = false;
      settings = {
        font = {
          normal = [ "CaskaydiaCove Nerd Font" ];
          size = if config.functorOS.formFactor == "laptop" then 11 else 13;
        };
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications =
        let
          desktopFile = cfg.browserDesktopFile;
        in
        {
          "text/html" = [ desktopFile ];
          "x-scheme-handler/http" = [ desktopFile ];
          "x-scheme-handler/https" = [ desktopFile ];
          "x-scheme-handler/about" = [ desktopFile ];
          "x-scheme-handler/unknown" = [ desktopFile ];
        };
    };

    home.packages = [ cfg.defaultBrowser ];

    home.sessionVariables.DEFAULT_BROWSER = lib.getExe cfg.defaultBrowser;
  };
}