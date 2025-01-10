{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
final: prev: {
  modrinth-app = callPackage ./by-name/modrinth-app { };
  rdrview = callPackage ./by-name/rdrview { };
  wine-discord-ipc-bridge = callPackage ./by-name/wine-discord-ipc-bridge { };
  hyprland-qtutils = callPackage ./by-name/hyprland-qtutils { };
}
