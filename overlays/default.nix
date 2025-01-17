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
        version = "0-unstable-2025-01-16";
        src = prev.fetchFromGitHub {
          owner = "dawsers";
          repo = "hyprscroller";
          rev = "e250f38bde9659ee8459c05a173bcc5c2655418f";
          hash = "sha256-rqDfY/wPG2F5NfHx6yEWMRybapNwmjjawQ7tWe6gDaw=";
        };
      };
    })
  ];
}
