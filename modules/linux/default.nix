{ lib, ... }:
{
  imports = [
    ./audio
    ./audio-prod
    ./core
    ./desktop-portal
    ./distrobox
    ./flatpak
    ./fonts
    ./gaming
    ./greeter
    ./hamachi
    ./networking
    ./spotifyd
    ./stylix
    ./wine
    ./wsl
  ];
}
