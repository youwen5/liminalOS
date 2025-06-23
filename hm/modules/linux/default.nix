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

  home.file = lib.mkIf config.liminalOS.programs.enable {
    ".config/vesktop/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${osConfig.liminalOS.flakeLocation}/hm/modules/linux/var/settings.json";
  };

  services.gnome-keyring.enable = true;
}
