{
  spicepkgs,
  config,
  osConfig,
  lib,
  ...
}:
{
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
