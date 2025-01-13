# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "adrastea";

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
    extras.distrobox.enable = true;
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
    initrd.luks.devices."luks-52d1be6d-b32f-41e0-a6d7-2ff52599fe7c".device =
      "/dev/disk/by-uuid/52d1be6d-b32f-41e0-a6d7-2ff52599fe7c";
  };

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  services.tlp.enable = lib.mkForce false;

  powerManagement.cpuFreqGovernor = "performance";

  time.timeZone = "America/Los_Angeles";

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = true;
  #   powerManagement.finegrained = false;
  #   nvidiaSettings = true;
  #   open = true;
  #   # prime = {
  #   #   amdgpuBusId = "PCI:4:0:0";
  #   #   nvidiaBusId = "PCI:1:0:0";
  #   #   # offload = {
  #   #   #   enable = true;
  #   #   #   enableOffloadCmd = true;
  #   #   # };
  #   #   sync.enable = true;
  #   # };
  # };

  hardware.graphics.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services.xserver.videoDrivers = [ "nvidia" ];

  nixpkgs.config.allowUnfree = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
