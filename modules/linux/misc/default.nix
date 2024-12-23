{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.liminalOS.system;
  inherit (lib) mkIf;
in
{
  options.liminalOS.system = {
    printing.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to set up default options for printing and printer discover on UNIX.
      '';
    };
    fonts.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to set up some nice default fonts, including a Nerd Font, Noto Fonts, and CJK.
      '';
    };
    distrobox.enable = lib.mkEnableOption "distrobox and podman";
  };

  config = {
    services.printing.enable = mkIf cfg.printing.enable true;

    services.avahi = mkIf cfg.printing.enable {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    fonts = mkIf cfg.fonts.enable {
      enableDefaultPackages = true;
      packages =
        with pkgs;
        [
          noto-fonts-cjk-sans
          (google-fonts.override { fonts = [ "Lora" ]; })
        ]
        ++ (lib.optionals (!config.liminalOS.theming.enable) [
          noto-fonts
          noto-fonts-emoji
          nerd-fonts.caskaydia-cove
        ]);
    };

    virtualisation.podman = mkIf cfg.distrobox.enable {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = mkIf cfg.distrobox.enable [ pkgs.distrobox ];
  };
}
