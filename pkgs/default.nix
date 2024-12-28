{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
final: prev: {
  modrinth-app = callPackage ./by-name/modrinth-app { };
  # hyprland-qtutils = callPackage ./by-name/hyprland-qtutils { };
  rdrview = callPackage ./by-name/rdrview { };
}
