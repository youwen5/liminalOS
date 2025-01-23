{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
final: prev: {
  rdrview = callPackage ./by-name/rdrview { };
  wine-discord-ipc-bridge = callPackage ./by-name/wine-discord-ipc-bridge { };
  modrinth-app-bin = callPackage ./by-name/modrinth-app-bin { };
}
