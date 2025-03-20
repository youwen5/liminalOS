{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.programs.wine;
in
{
  options.liminalOS.programs.wine.enable = lib.mkEnableOption "wine";

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
