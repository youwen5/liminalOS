{ lib, config, ... }:
let
  cfg = config.liminalOS.system.audio;
in
{
  options.liminalOS.system.audio.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liminalOS.enable;
    description = ''
      Whether to set up PipeWire and default audio utilities.
    '';
  };

  config = {
    services.playerctld.enable = lib.mkIf cfg.enable true;
    services.pulseaudio.enable = lib.mkIf cfg.enable false;
    services.pipewire = lib.mkIf cfg.enable {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
