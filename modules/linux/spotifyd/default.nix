{pkgs, ...}: {
  services.spotifyd = {
    enable = true;
    # settings = {global = 320;};
  };
  environment.systemPackages = [
    pkgs.spotify-player
  ];
}
