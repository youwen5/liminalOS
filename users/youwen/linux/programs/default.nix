{
  pkgs,
  inputs,
  ...
}:
{
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
      allow_remote_control = "socket-only";
      listen_on = "unix:/tmp/kitty";
      scrollback_pager = ''nvim --noplugin -c "set signcolumn=no showtabline=0 clipboard=unnamedplus" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - "'';
    };
    keybindings = {
      "kitty_mod+h" = "show_scrollback";
    };
  };

  # programs.firefox = {
  #   enable = true;
  #   # package = pkgs.librewolf;
  #   profiles = {
  #     Personal = {
  #       name = "Youwen Wu";
  #       settings = {
  #         webgl.disabled = false;
  #         privacy.resistFingerprinting = false;
  #         privacy.clearOnShutdown.history = false;
  #         privacy.clearOnShutdown.cookies = false;
  #         network.cookie.lifetimePolicy = 0;
  #         search.default = "Google";
  #         search.force = true;
  #         search.engines = {
  #           "Nix Packages" = {
  #             urls = [
  #               {
  #                 template = "https://search.nixos.org/packages";
  #                 params = [
  #                   {
  #                     name = "type";
  #                     value = "packages";
  #                   }
  #                   {
  #                     name = "query";
  #                     value = "{searchTerms}";
  #                   }
  #                 ];
  #               }
  #             ];
  #
  #             icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  #             definedAliases = ["@np"];
  #           };
  #
  #           "NixOS Wiki" = {
  #             urls = [{template = "https://wiki.nixos.org/index.php?search={searchTerms}";}];
  #             iconUpdateURL = "https://wiki.nixos.org/favicon.png";
  #             updateInterval = 24 * 60 * 60 * 1000; # every day
  #             definedAliases = ["@nw"];
  #           };
  #
  #           "Google" = {
  #             urls = [
  #               {
  #                 template = "https://www.google.com/search";
  #                 params = [
  #                   {
  #                     name = "q";
  #                     value = "{searchTerms}";
  #                   }
  #                   {
  #                     name = "udm";
  #                     value = "14";
  #                   }
  #                 ];
  #               }
  #             ];
  #             definedAliases = ["@g"];
  #           };
  #         };
  #       };
  #       extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
  #         ublock-origin
  #         bitwarden
  #         vimium
  #         tabliss
  #         privacy-badger
  #         reddit-enhancement-suite
  #         catppuccin
  #       ];
  #     };
  #   };
  # };
}
