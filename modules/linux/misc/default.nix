{ config, lib, ... }:
let
  cfg = config.liminalOS.system.printing;
in
{
  options.liminalOS.system.printing = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to set up default options for printing and printer discover on UNIX.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
