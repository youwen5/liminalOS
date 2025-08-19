{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
{
  imports = [
    ./var/easyeffects
    ./programs
    ./spicetify
    ./desktop-environment
    ./theming
    ./platform-tweaks
    ./tidal-hifi
    ./var/mangohud
  ];

  programs.fish.functions = lib.mkIf config.liminalOS.programs.enable {
    # rebuild = ''doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} switch &| nom'';
    # os-test = ''doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} test &| nom'';
    # nixos-update = ''
    #   cd ~/.config/liminalOS
    #   nix flake update --commit-lock-file
    #   doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} switch &| nom
    # '';
    spt = "${lib.getExe pkgs.spotify-player}";
  };

  services.gnome-keyring.enable = true;
}
