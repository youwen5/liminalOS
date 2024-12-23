{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.extras.gaming;
in
{
  options.liminalOS.extras.gaming = {
    enable = lib.mkEnableOption "gaming";
    withHamachi = lib.mkEnableOption "hamachi";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ryujinx
      lutris
      heroic
      mangohud
      mangojuice
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };

    programs.gamescope.enable = true;

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode engaged'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode disengaged'";
        };
      };
    };

    users.users.${config.liminalOS.username}.extraGroups = [ "gamemode" ];

    services.logmein-hamachi.enable = cfg.withHamachi;
    programs.haguichi.enable = cfg.withHamachi;

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            (writeShellScriptBin "launch-gamescope" ''
              (sleep 1; pgrep gamescope| xargs renice -n -11 -p)&
              exec gamescope "$@"
            '')
            keyutils
          ];
      };
    };
  };
}
