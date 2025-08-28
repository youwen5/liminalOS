{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.functorOS.extras.distrobox;
in
{
  options.functorOS.extras.distrobox.enable = lib.mkEnableOption "distrobox and podman";

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.systemPackages = [ pkgs.distrobox ];
  };
}