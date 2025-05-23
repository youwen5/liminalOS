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

  config = lib.mkIf cfg.enable {
    services.playerctld.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      # extraConfig.pipewire = {
      #   bluez = {
      #     bluez5.a2dp.latency.msec = 200;
      #   };
      # };
    };
  };
}
