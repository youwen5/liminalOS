{ lib, ... }:
{
  imports = [
    ./audio
    ./audio-prod
    ./core
    ./desktop-environment
    ./distrobox
    ./flatpak
    ./gaming
    ./greeter
    ./misc
    ./networking
    ./stylix
    ./wine
    ./wsl
  ];

  options.liminalOS.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether to enable liminalOS's default modules and options for Linux.
    '';
  };
}
