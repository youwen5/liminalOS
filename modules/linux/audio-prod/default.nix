{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.system.audio.prod;
in
{
  options.liminalOS.system.audio.prod.enable = lib.mkEnableOption "audio production";

  config = lib.mkIf cfg.enable {
    liminalOS = {
      programs.wine.enable = true;
      system.audio.enable = true;
    };

    environment.systemPackages = with pkgs; [
      reaper
      yabridge
      yabridgectl
    ];

    liminalOS.config.extraUnfreePackages = lib.mkIf config.liminalOS.config.allowUnfree [
      "reaper"
    ];
  };
}
