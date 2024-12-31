# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "demeter";

  liminalOS = {
    flakeLocation = "/home/youwen/.config/liminalOS";
    config.allowUnfree = true;
    defaultEditor = inputs.viminal.packages.${pkgs.system}.default;
    formFactor = "desktop";
    system = {
      audio.prod.enable = true;
      networking = {
        firewallPresets.vite = true;
        cloudflareNameservers.enable = true;
      };
      graphics.nvidia.enable = true;
    };
    extras.gaming = {
      enable = true;
      roblox.enable = true;
      utilities.gamemode = {
        enable = true;
        gamemodeUsers = [ "youwen" ];
      };
    };
  };

  time.timeZone = "America/Los_Angeles";

  hardware.cpu.intel.updateMicrocode = true;

  # Bootloader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 15;
      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      systemd-boot = {
        enable = false;
        consoleMode = "auto";
      };
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    kernelPackages = pkgs.linuxPackages_zen;

    initrd.luks.devices."luks-af320a0f-b388-43f5-b5a3-af2b47cfc716".device =
      "/dev/disk/by-uuid/af320a0f-b388-43f5-b5a3-af2b47cfc716";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
