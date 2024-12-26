{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.liminalOS.programs.bulk;
  mkEnableOption' =
    desc:
    lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable ${desc}.
      '';
    };
in
{
  options.liminalOS.programs.bulk = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.programs.enable;
      description = ''
        Whether to enable installation of various useful programs in the system.
      '';
    };
    archiveTools.enable = mkEnableOption' "archive tools";
    instantMessaging.enable = mkEnableOption' "instant messengers";
    nixCliTools.enable = mkEnableOption' "Nix CLI helper tools and utilities";
    desktopApps.enable = mkEnableOption' "desktop applications like mail and file explorer";
    misc.enable = mkEnableOption' "assorted uncategorized utilities";
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      lib.optionals cfg.archiveTools.enable (
        with pkgs;
        [
          zip
          xz
          unzip
          p7zip
        ]
      )
      ++ lib.optionals cfg.nixCliTools.enable (
        with pkgs;
        [
          nurl
          nix-output-monitor
        ]
      )
      ++ lib.optionals cfg.misc.enable (
        with pkgs;
        [
          ffmpeg

          pciutils # lspci
          usbutils # lsusb

          ani-cli
          manga-tui

          hledger
        ]
      )
      ++ lib.optionals cfg.instantMessaging.enable (
        with pkgs;
        [
          vesktop
          signal-desktop
          iamb
        ]
        ++ lib.optionals cfg.desktopApps.enable (
          with pkgs;
          [
            thunderbird
            xfce.thunar
          ]
          ++ lib.optionals pkgs.stdenv.targetPlatform.isx86_64 [
            bitwarden-desktop
            sbctl
          ]
          ++ lib.optionals pkgs.stdenv.targetPlatform.isAarch64 [ ]
        )
      );
  };
}