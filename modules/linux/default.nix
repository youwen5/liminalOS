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
    ./graphics
    ./localization
  ];

  options.functorOS.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether to enable functorOS's default modules and options for Linux.
    '';
  };

  options.functorOS._users = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    description = ''
      INTERNAL functorOS OPTION --- DO NOT SET!
    '';
    default = [ ];
  };
}

