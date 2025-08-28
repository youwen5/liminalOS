{
  spicepkgs,
  config,
  osConfig,
  lib,
  ...
}:
{
  config = lib.mkIf (config.functorOS.programs.enable && osConfig.functorOS.config.allowUnfree) {
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