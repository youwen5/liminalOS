{ lib, config, ... }:
let
  cfg = config.liminalOS.system.audio;
in
{
  options.liminalOS.system.audio.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.liminalOS.linux.enable;
    description = ''
      Whether to set up PipeWire and default audio utilities.
    '';
  };

  config = {
    services.playerctld.enable = lib.mkIf cfg.enable true;
    hardware.pulseaudio.enable = lib.mkIf cfg.enable false;
    # TODO: move to other file
    security.rtkit.enable = true;
    services.pipewire = lib.mkIf cfg.enable {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
