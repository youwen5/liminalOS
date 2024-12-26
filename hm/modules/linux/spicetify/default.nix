{
  liminalHomeManagerModules,
  pkgs,
  config,
  osConfig,
  lib,
  ...
}:
let
  spicepkgs = liminalHomeManagerModules.spicetify.legacyPackages.${pkgs.system};
in
{
  imports = [
    liminalHomeManagerModules.spicetify.homeManagerModules.default
  ];

  config = lib.mkIf (config.liminalOS.programs.enable && osConfig.liminalOS.config.allowUnfree) {
    programs.spicetify = {
      enable = true;
      # theme = spicepkgs.themes.dribbblish;
      # colorScheme = "rosepine";
      enabledExtensions = with spicepkgs.extensions; [
        lastfm
        fullAppDisplayMod
      ];
      enabledCustomApps = with spicepkgs.apps; [
        lyricsPlus
      ];
    };
  };
}
