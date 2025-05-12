{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.liminalOS;
  inherit (lib) mkIf;
in
{
  options.liminalOS = {
    system.printing.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to set up default options for printing and printer discover on UNIX.
      '';
    };
    system.fonts.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to set up some nice default fonts, including a Nerd Font, Noto Fonts, and CJK.
      '';
    };
    config.allowUnfree = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable some proprietary packages required by certain liminalOS modules. This does not set allowUnfree for the whole system, it merely allows the installation of a few proprietary packages such as Nvidia drivers, etc. You should still set this option even if you already set nixpkgs.config.allowUnfree for the whole system since it tells liminalOS it can enable certain options that require  proprietary packages.
      '';
    };
    config.extraUnfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Packages to enable in allowUnfreePredicate
      '';
    };
    flakeLocation = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Absolute filepath location of the NixOS system configuration flake.
      '';
    };
    useEnUsLocale = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to use the en_US locale automatically";
    };
    defaultEditor = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = pkgs.neovim;
      description = "Default text editor that will be installed and set as $EDITOR. Set to null to disable setting and installing default text editor.";
    };
    formFactor = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "laptop"
          "desktop"
        ]
      );
      default = null;
      description = ''
        Form factor of the machine. Adjusts some UI settings.
      '';
    };
    powersave = lib.mkOption {
      type = lib.types.bool;
      default = cfg.formFactor == "laptop";
      description = ''
        Whether to set some options to reduce power consumption (mostly Hyprland).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = mkIf cfg.system.printing.enable true;

    services.avahi = mkIf cfg.system.printing.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    fonts = mkIf cfg.system.fonts.enable {
      enableDefaultPackages = true;
      packages =
        with pkgs;
        [
          noto-fonts-cjk-sans
          (google-fonts.override {
            fonts = [
              "Lora"
              "Inter"
              "Source Sans 3"
            ];
          })
          nerd-fonts.geist-mono
        ]
        ++ (lib.optionals (!config.liminalOS.theming.enable) [
          noto-fonts
          noto-fonts-emoji
          nerd-fonts.caskaydia-cove
        ]);
    };

    nixpkgs.config.allowUnfreePredicate = lib.mkIf config.liminalOS.config.allowUnfree (
      pkg:
      builtins.elem (pkgs.lib.getName pkg) (
        config.liminalOS.config.extraUnfreePackages
        ++ [
          "spotify"
        ]
      )
    );

    environment.variables.EDITOR = lib.mkIf (
      cfg.defaultEditor != null
    ) cfg.defaultEditor.meta.mainProgram;

    environment.systemPackages = lib.mkIf (cfg.defaultEditor != null) [ cfg.defaultEditor ];

    # Select internationalisation properties.
    i18n = lib.mkIf cfg.useEnUsLocale {
      defaultLocale = "en_US.UTF-8";

      extraLocaleSettings = {
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
    };

    assertions = [
      {
        assertion = cfg.formFactor != null;
        message = ''
          You must set `liminalOS.formFactor` to either "laptop" or "desktop"!
        '';
      }
    ];
  };
}
