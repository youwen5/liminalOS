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
    theme = spicepkgs.themes.catppuccin;
    colorScheme = "mocha";
    enabledExtensions = with spicepkgs.extensions; [
      lastfm
    ];
  };
}
