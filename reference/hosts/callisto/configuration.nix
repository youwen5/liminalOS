# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  pkgs,
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
    theming = {
      wallpaper = "${inputs.wallpapers}/aesthetic/afterglow_city_skyline_at_night.png";
      # if you don't manually set polarity when using manual colorscheme, GTK
      # apps won't respect colorscheme
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      polarity = "dark";
    };
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
    kernelParams = [ "apple_dcp.show_notch=1" ];
    extraModprobeConfig = ''
      options hid_apple iso_layout=0
    '';
  };

  hardware.asahi = {
    peripheralFirmwareDirectory = "${inputs.apple-firmware}/firmware";
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "overlay";
  };

  nixpkgs.overlays = [
    inputs.apple-silicon.overlays.apple-silicon-overlay
    inputs.vesktop-bin.overlays.default
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
