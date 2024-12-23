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
    utilities.hamachi.enable = lib.mkEnableOption "hamachi";
    roblox.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.extras.gaming && cfg.enable;
      description = ''
        Whether to install the Roblox Sober flatpak automatically. Note that this will enable the nix-flatpak service and automatic flatpak updates.`
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ryujinx
      lutris
      heroic
      mangohud
      mangojuice
    ];

    liminalOS.programs.flatpaks.enable = true;

    services.flatpak.packages = lib.mkIf cfg.roblox.enable [
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "sha256:1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
      {
        appId = "org.vinegarhq.Sober";
        origin = "sober";
      }
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

    services.logmein-hamachi.enable = cfg.utilities.hamachi.enable;
    programs.haguichi.enable = cfg.utilities.hamachi.enable;

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
