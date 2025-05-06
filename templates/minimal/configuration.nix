# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}:
rec {
  imports = [
    # Important: you should replace hardware-configuration.nix with your actual
    # hardware-configuration.nix generated during NixOS installation, located
    # at /etc/nixos/hardware-configuration.nix! If you don't have this file,
    # re-run nixos-install to generate it.
    ./hardware-configuration.nix
  ];

  networking.hostName = "liminalOS"; # Define your hostname.

  liminalOS = {
    # Set this to the absolute path of the location of this configuration flake
    # to enable some UX enhanacements
    flakeLocation = null;
    config.allowUnfree = true;
    # Set your default editor to any program.
    defaultEditor = pkgs.helix;
    # Set to either "laptop" or "desktop" for some adjustments
    formFactor = "desktop";
    # Set a wallpaper to whatever you want! You can use a local path as well.
    # The colorscheme for the system is automatically generated from this
    # wallpaper!
    theming = {
      wallpaper = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/l8/wallhaven-l8x1pr.jpg";
        hash = "sha256-Ts8igtDxLsnAnpy+tiGAXVhJWYLMHGOb2fd8lpV+UnM=";
      };
    };
    system = {
      # Toggle true to enable audio production software, like reaper, and yabridge + 64 bit wine for
      # installing Windows-exclusive VSTs!
      audio.prod.enable = false;

      networking = {
        # Toggle on to allow default vite ports of 5173 and 4173 through the firewall for local testing!
        firewallPresets.vite = false;
        # Use cloudflare's 1.1.1.1 DNS servers
        cloudflareNameservers.enable = true;
      };
      graphics.nvidia.enable = true;
    };
    extras.gaming = {
      # Enable gaming utilities, like Heroic, Lutris, Steam
      enable = false;
      # Installs Roblox using Sober, as a flatpak. Note that this will enable
      # the impure flatpak service that automatically updates flatpaks every
      # week upon nixos-rebuild switch
      roblox.enable = false;

      utilities.gamemode = {
        # enable the gamemoderun binary to maximize gaming performance
        enable = false;
        # don't forget to update this if you change your username!
        gamemodeUsers = [ "default-user" ];
      };
    };
  };

  # Set up a user
  users.users.default-user = {
    isNormalUser = true;
    description = "Default liminalOS user!";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  home-manager.users.default-user = {
    imports = [ ./home.nix ];
  };
  home-manager.extraSpecialArgs = { inherit inputs; };

  # Set your time zone
  time.timeZone = "America/Los_Angeles";

  # Bootloader and kernel.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 15;
      systemd-boot = {
        enable = true;
      };
    };
  };

  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "24.05"; # Did you read the comment?
    
    # Automatically rebuild system daily
    autoUpgrade = {
      enable = true;
      flake = liminalOS.flakeLocation;
      flags = [
        "-L" # print build logs
      ];
      dates = "daily";
    };
  };
}
