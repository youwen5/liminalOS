# Edit this configuration file to define what should be installed on
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

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  virtualisation.waydroid.enable = true;

  liminalOS = {
    flakeLocation = "/home/youwen/.config/liminalOS";
    config.allowUnfree = true;
    defaultEditor = inputs.viminal.packages.${pkgs.system}.default;
    formFactor = "desktop";
    system = {
      audio.prod.enable = true;
      audio.prod.realtimeAudioUsers = [ "youwen" ];
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
    kernelParams = [ "microcode.amd_sha_check=off" ];
  };

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  services.udev.extraRules = ''
    ACTION=="add" SUBSYSTEM=="pci" ATTR{vendor}=="0x1022" ATTR{device}=="0x1639" ATTR{power/wakeup}="disabled"
  '';

  services.tlp.enable = lib.mkForce false;

  powerManagement.cpuFreqGovernor = "performance";

  # time.timeZone = "America/Los_Angeles";
  time.timeZone = "Asia/Shanghai";

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    # nvidiaSettings = true;
    open = true;
    prime = {
      amdgpuBusId = "PCI:4:0:0";
      nvidiaBusId = "PCI:1:0:0";
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      sync.enable = true;
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            leftalt = "leftcontrol";
            leftcontrol = "leftalt";
            rightalt = "layer(rightalt)";
          };
          rightalt = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          };
        };
      };
    };
  };

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
