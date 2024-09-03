{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ryujinx
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
  };

  programs.gamescope.enable = true;

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
}
