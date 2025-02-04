{
  pkgs,
  lib,
  ...
}:
let
  # bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
  inherit (pkgs) system;
in
# stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
# nixpkgs-small = inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system};
{
  nixpkgs.overlays = [
    (import ../pkgs { inherit pkgs; })
    (final: prev: {
      hyprlandPlugins.hyprscroller = prev.hyprlandPlugins.hyprscroller.overrideAttrs {
        version = "0.47.2";
        src = prev.fetchFromGitHub {
          owner = "dawsers";
          repo = "hyprscroller";
          rev = "ce7503685297d88e0bb0961343ed3fbed21c559c";
          hash = "";
        };
      };
    })
  ];
}
