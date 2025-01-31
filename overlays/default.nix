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
      hyprlandPlugins.hyprscroller =
        if (lib.versionAtLeast pkgs.hyprland.version "0.47.1") then
          prev.hyprlandPlugins.hyprscroller.overrideAttrs {
            version = "0.47.1";
            src = prev.fetchFromGitHub {
              owner = "dawsers";
              repo = "hyprscroller";
              rev = "e4b13544ef3cc235eb9ce51e0856ba47eb36e8ac";
              hash = "sha256-OYCcIsE25HqVBp8z76Tk1v+SuYR7W1nemk9mDS9GHM8=";
            };
          }
        else
          prev.hyprlandPlugins.hyprscroller.overrideAttrs {
            version = "0.47.0";
            src = prev.fetchFromGitHub {
              owner = "dawsers";
              repo = "hyprscroller";
              rev = "ce7503685297d88e0bb0961343ed3fbed21c559c";
              hash = "sha256-3pGIe4H1LUOJw0ULfVwZ7Ph7r/AyEipx7jbWP7zz3MU=";
            };
          };
    })
  ];
}
