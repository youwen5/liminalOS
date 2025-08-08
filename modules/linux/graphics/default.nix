{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.liminalOS.system.graphics;
in
{
  options.liminalOS.system.graphics = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to set up basic graphics settings and options.
      '';
    };
    nvidia = {
      enable = lib.mkEnableOption "recommended nvidia drivers and configuration";
      optimus-prime.enable = lib.mkEnableOption "Nvidia OPTIMUS and PRIME";
      optimus-prime.powerMode = lib.mkOption {
        type = lib.types.enum [
          "powersaving"
          "performance"
        ];
        default = "performance";
        description = ''
          Whether to use Nvidia OPTIMUS with maximum performance using the discrete graphics card, or to use offload mode to primarily use the integrated GPU and save power.
        '';
      };
      suppressUnfreeWarning = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to disable the assertion that warns the user if they try to enable proprietary nvidia drivers without setting allowUnfree.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = lib.mkIf cfg.nvidia.enable {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      nvidiaSettings = true;
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
      ];
    };

    services.xserver.videoDrivers = lib.mkIf cfg.nvidia.enable [ "nvidia" ];

    liminalOS.config.extraUnfreePackages = lib.mkIf cfg.nvidia.enable [
      "nvidia-x11"
      "nvidia-settings"
    ];

    assertions = [
      {
        assertion =
          !cfg.nvidia.enable
          || (config.liminalOS.config.allowUnfree && cfg.nvidia.enable)
          || cfg.nvidia.suppressUnfreeWarning;
        message = "You enabled Nvidia proprietary driver installation but did not allow unfree packages to be installed! Consider setting liminalOS.config.allowUnfree = true or nixpkgs.config.allowUnfree = true. If you are using an allowUnfreePredicate to whitelist these packages manually, you can set liminalOS.system.graphics.nvidia.suppressUnfreeWarning = true";
      }
    ];
  };
}
