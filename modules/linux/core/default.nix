{
  inputs,
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
    flakeLocation = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = ''
        Absolute filepath location of the NixOS system configuration flake.
      '';
    };
    suppressWarnings = lib.mkEnableOption "suppress warnings";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.viminal.packages.${pkgs.system}.default
    ];

    environment.variables = {
      EDITOR = "nvim";
    };

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
        ];
        trusted-public-keys = [
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        ];
      };

      channel.enable = false;
    };

    programs.nh = lib.mkIf cfg.useNh {
      enable = true;
      clean = lib.mkIf cfg.nixSaneDefaults {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
      flake = cfg.flakeLocation;
    };

    boot.tmp.cleanOnBoot = true;

    warnings =
      if !cfg.suppressWarnings && cfg.useNh && cfg.flakeLocation == "" then
        [
          ''The `nh` CLI is enabled but `liminalOS.system.core.flakeLocation` is not set. It is recommended that you set this option so that `nh` can work without specifying the flake path every time. You can disable this warning by setting `liminalOS.system.core.suppressWarnings`.''
        ]
      else
        [ ];

  };
}
