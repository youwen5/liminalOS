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
      ++ (lib.optionals config.liminalOS.config.allowUnfree (
        with pkgs;
        [
          (reaper.overrideAttrs (
            finalAttrs: prevAttrs: {
              installPhase = ''
                runHook preInstall

                HOME="$out/share" XDG_DATA_HOME="$out/share" ./install-reaper.sh \
                  --install $out/opt \
                  --integrate-user-desktop
                rm $out/opt/REAPER/uninstall-reaper.sh

                # Dynamic loading of plugin dependencies does not adhere to rpath of
                # reaper executable that gets modified with runtimeDependencies.
                # Patching each plugin with DT_NEEDED is cumbersome and requires
                # hardcoding of API versions of each dependency.
                # Setting the rpath of the plugin shared object files does not
                # seem to have an effect for some plugins.
                # We opt for wrapping the executable with LD_LIBRARY_PATH prefix.
                # Note that libcurl and libxml2 are needed for ReaPack to run.
                wrapProgram $out/opt/REAPER/reaper \
                  --prefix LD_LIBRARY_PATH : "${
                    lib.makeLibraryPath [
                      curl
                      lame
                      libxml2
                      ffmpeg
                      vlc
                      xdotool
                      stdenv.cc.cc
                    ]
                  }" \
                  --prefix PIPEWIRE_LATENCY : "128/48000"

                mkdir $out/bin
                ln -s $out/opt/REAPER/reaper $out/bin/

                runHook postInstall
              '';
            }
          ))
        ]
      ))
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
