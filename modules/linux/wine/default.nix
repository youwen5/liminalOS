{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.functorOS.programs.wine;
in
{
  options.functorOS.programs.wine.enable = lib.mkEnableOption "wine";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = (
      with pkgs;
      [
        winetricks
        wine
      ]
    );
  };
}