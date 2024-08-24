{
  inputs,
  pkgs,
  ...
}: let
  spicepkgs = inputs.spicetify.legacyPackages.${pkgs.system};
in {
  imports = [
    inputs.spicetify.homeManagerModules.default
  ];

  programs.spicetify = {
    enable = true;
    theme = spicepkgs.themes.dribbblish;
    colorScheme = "rosepine";
    enabledExtensions = with spicepkgs.extensions; [
      lastfm
      fullAppDisplayMod
    ];
    enabledCustomApps = with spicepkgs.apps; [
      lyricsPlus
    ];
  };
}
