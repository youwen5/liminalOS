{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.extras.distrobox;
in
{
  options.liminalOS.extras.distrobox.enable = lib.mkEnableOption "distrobox and podman";

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = [ pkgs.distrobox ];
  };
}
