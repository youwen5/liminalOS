{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.system.core;
in
{
  options.liminalOS.system.core = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to enable core liminalOS system utilities and configurations (such as security policies, Nix options, etc)
      '';
    };
    replaceSudoWithDoas = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to replace sudo with doas, the Dedicated OpenBSD Application Subexecutor. Doas is the preferred liminalOS setuid program.
      '';
    };
    waylandFixes = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable some Wayland fixes, like setting NIXOS_OZONE_WL to hint Electron apps to use the Wayland windowing system.
      '';
    };
    nixSaneDefaults = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to set sane defaults for Nix, such as optimization and automatic garbage collection.
      '';
    };
    useNh = lib.mkOption {
      type = lib.types.bool;
      default = cfg.nixSaneDefaults;
      description = ''
        Whether to enable the `nh` cli (yet another Nix helper), a reimplementation of some core NixOS utilities like nix-collect-garbage and nixos-rebuild. If enabled, automatic garbage collection will use `nh` instead of `nix-collect-garbage` and will be able to garbage collect `result` symlinks.
      '';
    };
    suppressWarnings = lib.mkEnableOption "suppress warnings";
    bluetooth.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable bluetooth and blueman.
      '';
    };
    uutils.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to replace GNU coreutils with Rust uutils
      '';
    };
    useGvfs.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to enable the GVFS and alias `rm` to send files to trash instead.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (with pkgs; [
        wget
        git
        curl
      ])
      ++ [
        config.liminalOS.defaultEditor
      ]
      ++ lib.optionals cfg.replaceSudoWithDoas [ pkgs.doas-sudo-shim ]
      ++ lib.optionals cfg.uutils.enable [
        (lib.hiPrio pkgs.uutils-coreutils-noprefix)
      ];

    # tells electron apps to use Wayland
    environment.sessionVariables = lib.mkIf cfg.waylandFixes {
      NIXOS_OZONE_WL = "1";
    };

    security = {
      sudo.enable = !cfg.replaceSudoWithDoas;

      doas = lib.mkIf cfg.replaceSudoWithDoas {
        enable = true;
        extraRules = [
          {
            users = [ "youwen" ];
            keepEnv = true;
            persist = true;
          }
        ];
      };

      rtkit.enable = true;
    };

    services.gnome.gnome-keyring.enable = true;

    services.resolved.enable = true;

    nix = lib.mkIf cfg.nixSaneDefaults {
      gc = lib.mkIf (!cfg.useNh) {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      optimise.automatic = true;
      # Free up to 1GiB when there is less than 100MiB left
      extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://hyprland.cachix.org"
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
        trusted-users = [ "@wheel" ];
      };

      channel.enable = false;
    };

    programs.nh = lib.mkIf cfg.useNh {
      enable = true;
      clean = lib.mkIf cfg.nixSaneDefaults {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
      flake = config.liminalOS.flakeLocation;
    };

    # environment.variables = lib.mkIf (cfg.useNh && config.security.doas.enable) {
    #   NH_FLAKE = config.programs.nh.flake;
    # };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        icu
        xorg.libXtst
        xorg.libXi
      ];
    };

    boot.tmp.cleanOnBoot = true;

    hardware.enableRedistributableFirmware = true;

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    programs.dconf.enable = true;

    programs.fish.enable = true;

    services.tlp.enable = lib.mkIf (config.liminalOS.formFactor == "laptop") true;
    programs.light.enable = lib.mkIf (config.liminalOS.formFactor == "laptop") true;

    hardware.bluetooth = lib.mkIf cfg.bluetooth.enable {
      enable = true;
      powerOnBoot = true;
    };

    services.blueman.enable = lib.mkIf cfg.bluetooth.enable true;

    services.gvfs.enable = lib.mkIf cfg.useGvfs.enable true;

    warnings =
      if !cfg.suppressWarnings && cfg.useNh && config.liminalOS.flakeLocation == "" then
        [
          ''The `nh` CLI is enabled but `liminalOS.flakeLocation` is not set. It is recommended that you set this option to the absolute file path of your configuration flake so that `nh` can work without specifying the flake path every time. You can disable this warning by setting `liminalOS.system.core.suppressWarnings`.''
        ]
      else
        [ ];

  };
}
