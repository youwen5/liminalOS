{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.system.audio.prod;
  forAllUsers = lib.genAttrs cfg.realtimeAudioUsers;
in
{
  options.liminalOS.system.audio.prod = {
    enable = lib.mkEnableOption "audio production";
    realtimeAudioUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        List of users to add to the audio group for realtime capabilities.
      '';
    };
  };

  config = {
    liminalOS = lib.mkIf cfg.enable {
      programs.wine.enable = true;
      system.audio.enable = true;
      config.extraUnfreePackages = lib.mkIf config.liminalOS.config.allowUnfree [
        "reaper"
      ];
    };

    environment.systemPackages = lib.mkIf cfg.enable (
      (with pkgs; [
        yabridge
        yabridgectl
        alsa-scarlett-gui
      ])
      ++ (lib.optionals config.liminalOS.config.allowUnfree [
        pkgs.reaper
      ])
    );

    musnix.enable = cfg.enable;
    # PREEMPT_RT is merged into master
    musnix.kernel.realtime = false;

    musnix.das_watchdog.enable = cfg.enable;
    musnix.alsaSeq.enable = cfg.enable;
    musnix.rtcqs.enable = cfg.enable;
    users.users = forAllUsers (_: {
      extraGroups = [ "audio" ];
    });

    boot.kernelParams = lib.mkIf cfg.enable [
      "threadirqs"
    ];
  };
}
