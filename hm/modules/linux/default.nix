{
  pkgs,
  lib,
  config,
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
  ];

  programs.fish.functions = lib.mkIf config.liminalOS.programs.enable {
    # rebuild = ''doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} switch &| nom'';
    # os-test = ''doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} test &| nom'';
    # nixos-update = ''
    #   cd ~/.config/liminalOS
    #   nix flake update --commit-lock-file
    #   doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} switch &| nom
    # '';
    nh = {
      # wrapper for nh as it doesn't work with `doas`
      body = ''
        if count $argv > /dev/null
          if contains -- os $argv or contains -- clean $argv
            doas ${pkgs.nh}/bin/nh $argv -R
          else
            ${pkgs.nh}/bin/nh $argv
          end
        else
            ${pkgs.nh}/bin/nh
        end
      '';
    };
    spt = "${pkgs.spotify-player}/bin/spotify_player";
  };

  home.file = lib.mkIf config.liminalOS.programs.enable {
    ".config/vesktop/settings.json".source = config.lib.file.mkOutOfStoreSymlink ./var/settings.json;
  };
}
