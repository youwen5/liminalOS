# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "callisto";
  time.timeZone = "America/Los_Angeles";

  liminalOS = {
    flakeLocation = "/home/youwen/.config/liminalOS";
    config.allowUnfree = false;
    defaultEditor = inputs.viminal.packages.${pkgs.system}.default;
    formFactor = "laptop";
    system = {
      networking = {
        firewallPresets.vite = true;
        cloudflareNameservers.enable = true;
        backend = "iwd";
      };
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = false;
    kernelParams = lib.mkForce [
      "earlycon"
      "console=tty0"
      "boot.shell_on_fail"
      "nvme_apple.flush_interval=0"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "apple_dcp.show_notch=1"
      "root=fstab"
      "splash"
      "loglevel=0"
    ];
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };

  hardware.asahi = {
    peripheralFirmwareDirectory = "${inputs.apple-firmware}/firmware";
    useExperimentalGPUDriver = true;
  };

  nixpkgs.overlays = [
    inputs.apple-silicon.overlays.apple-silicon-overlay
    (final: prev: {
      vesktop = inputs.vesktop-bin.packages.${pkgs.system}.default.override {
        electronPageSizeFix = true;
      };
      signal-desktop = inputs.signal-desktop.packages.${pkgs.system}.default.override {
        electronPageSizeFix = true;
      };
    })
  ];

  services.udev.extraRules = ''
    KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="90", ATTR{charge_control_start_threshold}="85"
  '';

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            leftmeta = "leftcontrol";
            leftalt = "leftmeta";
            leftcontrol = "leftalt";
            rightmeta = "leftalt";
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

  system.stateVersion = "24.11";
}
