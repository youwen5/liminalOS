# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.

  boot = {
    plymouth = {
      enable = true;
      # theme = "rings";
      # themePackages = with pkgs; [
      #   # By default we would install all themes
      #   (adi1090x-plymouth-themes.override {
      #     selected_themes = [ "rings" ];
      #   })
      # ];
      font = "${config.stylix.fonts.monospace.package}/share/fonts/truetype/NerdFonts/CaskaydiaCove/CaskaydiaCoveNerdFontMono-Regular.ttf";
    };

    # Enable "Silent Boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      # "display=HDMI-A-1:2560x1440@144D"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader = {
      efi.canTouchEfiVariables = true;
      # timeout = 15;
      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      # timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
      };
    };
    initrd.systemd.enable = true;
  };

  services.ucodenix = {
    enable = true;
    cpuModelId = "00A50F00";
  };

  # boot.lanzaboote = {
  #   enable = false;
  #   pkiBundle = "/etc/secureboot";
  # };

  # services.keyd = {
  #   enable = true;
  #   keyboards = {
  #     default = {
  #       ids = [ "*" ];
  #       settings = {
  #         main = {
  #           capslock = "esc";
  #           leftalt = "leftcontrol";
  #           leftcontrol = "leftalt";
  #         };
  #       };
  #     };
  #   };
  # };

  boot.initrd.luks.devices."luks-52d1be6d-b32f-41e0-a6d7-2ff52599fe7c".device =
    "/dev/disk/by-uuid/52d1be6d-b32f-41e0-a6d7-2ff52599fe7c";

  services.tlp.enable = true;

  powerManagement = {
    powerDownCommands = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    cpuFreqGovernor = "performance";
  };

  networking.hostName = "adrastea"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # select kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      icu
      xorg.libXtst
      xorg.libXi
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
    open = true;
    # prime = {
    #   amdgpuBusId = "PCI:4:0:0";
    #   nvidiaBusId = "PCI:1:0:0";
    #   # offload = {
    #   #   enable = true;
    #   #   enableOffloadCmd = true;
    #   # };
    #   sync.enable = true;
    # };
  };

  hardware.graphics.enable = true;

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  services.xserver.videoDrivers = [ "nvidia" ];

  # services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.youwen = {
    isNormalUser = true;
    description = "Youwen Wu";
    extraGroups = [ "networkmanager" ];
  };

  nix.settings = {
    trusted-users = [
      "root"
      "youwen"
    ];
  };

  services.udev.extraRules = ''
    KERNEL=="cpu_dma_latency", GROUP="realtime"
  '';

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    curl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;

  programs.hyprland.enable = true;

  programs.zsh.enable = false;
  programs.fish.enable = true;
  users.users.youwen.shell = pkgs.fish;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
