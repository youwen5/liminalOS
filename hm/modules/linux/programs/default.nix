{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.programs;
in
{
  imports = [
    ./bulk-programs.nix
  ];

  options.liminalOS.programs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to set up many default desktop programs.
      '';
    };
    terminal.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to set up kitty terminal.
      '';
    };
    zen.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to install Zen Browser and set it as the default browser.
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
        cursor_text_color = pkgs.lib.mkForce "#1a1b26";
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
          size = if config.liminalOS.formFactor == "laptop" then 11 else 13;
        };
      };
    };

    xdg.mimeApps = lib.mkIf cfg.zen.enable {
      enable = true;
      defaultApplications = {
        "text/html" = [ "zen.desktop" ];
        "x-scheme-handler/http" = [ "zen.desktop" ];
        "x-scheme-handler/https" = [ "zen.desktop" ];
        "x-scheme-handler/about" = [ "zen.desktop" ];
        "x-scheme-handler/unknown" = [ "zen.desktop" ];
      };
    };

    home.packages = lib.mkIf cfg.zen.enable [
      pkgs.zen-browser
    ];

    home.sessionVariables.DEFAULT_BROWSER = lib.mkIf cfg.zen.enable "${pkgs.zen-browser}/bin/zen";
  };
}
