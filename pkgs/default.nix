{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
final: prev: {
  modrinth-app = callPackage ./by-name/modrinth-app { };
}
