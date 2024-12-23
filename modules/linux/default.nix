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
    ./networking
    ./stylix
    ./wine
    ./wsl
    ./misc
  ];
}
