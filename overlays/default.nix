{
  pkgs,
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
        version = "0-unstable-2025-01-30";
        src = prev.fetchFromGitHub {
          owner = "dawsers";
          repo = "hyprscroller";
          rev = "e4b13544ef3cc235eb9ce51e0856ba47eb36e8ac";
          hash = "sha256-OYCcIsE25HqVBp8z76Tk1v+SuYR7W1nemk9mDS9GHM8=";
        };
      };
    })
  ];
}
