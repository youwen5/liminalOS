{ pkgs, ... }:
{
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        bitrate = 320;
        use_mpris = true;
        device_type = "computer";
      };
    };
  };
}
