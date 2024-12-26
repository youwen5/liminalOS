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
    utilities = {
      hamachi.enable = lib.mkEnableOption "hamachi";
      gamemode = {
        enable = lib.mkEnableOption "gamemode";
        gamemodeUsers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            List of users to add to the gamemode group. Gamemode will likely not work unless you add your user to the group!
          '';
        };
      };
    };
    roblox.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.extras.gaming && cfg.enable;
      description = ''
        Whether to install the Roblox Sober flatpak automatically. Note that this will enable the nix-flatpak service and automatic flatpak updates.`
      '';
    };
  };
  config = lib.mkIf cfg.enable (
    let
      forAllGamemodeUsers = lib.genAttrs cfg.utilities.gamemode.gamemodeUsers;
    in
    {
      environment.systemPackages = with pkgs; [
        ryujinx
        lutris
        heroic
        mangohud
        mangojuice
        r2modman
        modrinth-app
      ];

      liminalOS.programs.flatpak.enable = true;

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

      liminalOS.config.extraUnfreePackages = lib.mkIf config.liminalOS.config.allowUnfree [
        "modrinth-app"
        "modrinth-app-unwrapped"
        "steam"
        "steam-unwrapped"
      ];

      users.users = forAllGamemodeUsers (username: {
        extraGroups = [ "gamemode" ];
      });

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

      warnings =
        if cfg.utilities.gamemode.enable && (builtins.length cfg.utilities.gamemode.gamemodeUsers == 0) then
          [
            ''You enabled gamemode without setting any gamemode users in `liminalOS.extras.gaming.utilities.gamemode.gamemodeUsers. Gamemode is unlikely to work unless you add your user to gamemodeUsers.''
          ]
        else
          [ ];
    }
  );
}
