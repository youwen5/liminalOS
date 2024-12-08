{ pkgs, inputs, ... }:
let
  # mkFirefoxModule = inputs.home-manager.mkFirefoxModule;
  mkFirefoxModule = import "${inputs.home-manager}/modules/programs/firefox/mkFirefoxModule.nix";
in
{

  imports = [
    (mkFirefoxModule {
      modulePath = [
        "programs"
        "zen"
      ];
      name = "Zen";
      wrappedPackageName = "zen-browser";
      unwrappedPackageName = "zen-browser-unwrapped";
      visible = true;

      platforms.linux = {
        configPath = ".zen";
        vendorPath = ".zen";
      };
      # platforms.darwin = {
      #   configPath = "Library/Application Support/Floorp";
      # };
    })
  ];
  programs.kitty = {
    enable = true;
    # themeFile = "rose-pine";
    font.name = "CaskaydiaCove Nerd Font";
    shellIntegration.enableFishIntegration = true;
    shellIntegration.enableBashIntegration = true;
    settings = {
      font_size = 12;
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

  programs.neovide = {
    enable = false;
    settings = {
      font = {
        normal = [ "CaskaydiaCove Nerd Font" ];
        size = 13;
      };
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
    };
  };

  programs.zen = {
    enable = true;
  };
}
