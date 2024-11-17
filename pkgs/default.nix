{ pkgs, ... }:
let
  inherit (pkgs) callPackage;
in
final: prev: {
  zen-browser-unwrapped = callPackage ./by-name/zen-browser-unwrapped/package.nix { };
  zen-browser = callPackage ./by-name/zen-browser/package.nix { };
}
