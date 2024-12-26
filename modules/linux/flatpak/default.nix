# NOTE: this module is IMPURE. Flatpaks are declaratively specified but not
# versioned. Therefore, they are not included in generational rollbacks and
# persist between generations. This is not ideal, but at least it is a better
# situation than imperative installation
{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.programs.flatpak;
in
{
  options.liminalOS.programs.flatpak = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable Nix flatpak support with some fixes as well as declarative flatpak management.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal.enable = true;
    services.flatpak = {
      enable = true;

      overrides = {
        global = {
          Context.sockets = [
            "wayland"
            "!x11"
            "!fallback-x11"
          ];

          Environment = {
            # Fix un-themed cursor in some Wayland apps
            XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
          };
        };
      };

      update.auto = {
        enable = true;
        onCalendar = "weekly";
      };
    };
  };
}
