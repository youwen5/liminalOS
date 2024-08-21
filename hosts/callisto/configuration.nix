# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # ./apple-silicon-support
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.asahi = {
    peripheralFirmwareDirectory = ./firmware;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "overlay";
  };

  boot.extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';

  boot.kernelParams = ["apple_dcp.show_notch=1"];

  networking.hostName = "callisto"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  nixpkgs.overlays = [
    inputs.apple-silicon.overlays.apple-silicon-overlay
    (final: prev: {
      hyprland = prev.hyprland.overrideAttrs (oldAttrs: {
        src = oldAttrs.src;
        patches =
          oldAttrs.patches
          or []
          ++ [
            ./asahi-fix.patch
          ];
      });
    })
  ];

  programs.light.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  # networking.networkmanager.enable = true;

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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = false;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [icu xorg.libXtst xorg.libXi];
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.youwen = {
    isNormalUser = true;
    description = "Youwen Wu";
    extraGroups = ["networkmanager" "wheel" "nixos" "realtime"];
  };

  users.groups.realtime = {};

  nix.settings = {
    trusted-users = ["root" "youwen"];
    experimental-features = ["nix-command" "flakes"];
  };

  services.udev.extraRules = ''
    KERNEL=="cpu_dma_latency", GROUP="realtime"
    KERNEL=="macsmc-battery", SUBSYSTEM=="power_supply", ATTR{charge_control_end_threshold}="80", ATTR{charge_control_start_threshold}="70"
  '';

  security.pam.loginLimits = [
    {
      domain = "@realtime";
      type = "-";
      item = "rtprio";
      value = 98;
    }
    {
      domain = "@realtime";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@realtime";
      type = "-";
      item = "nice";
      value = -11;
    }
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    curl
  ];

  environment.variables = {
    EDITOR = "nvim";
    NIX_AUTO_RUN = 1;
  };
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
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
            i = "up";
            j = "left";
            k = "down";
            l = "right";
          };
        };
      };
    };
  };

  services.tlp.enable = true;

  # tells electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.dconf.enable = true;

  programs.hyprland.enable = true;
  # programs.hyprland.package = inputs.stablepkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.hyprland;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

  programs.zsh.enable = false;
  programs.fish.enable = true;
  users.users.youwen.shell = pkgs.fish;
}
