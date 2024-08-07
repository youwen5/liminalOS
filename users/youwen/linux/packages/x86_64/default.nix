{ pkgs, ... }:
let createCommon = import ../common-packages.nix;
in {
  home.packages = ((createCommon pkgs) ++ (with pkgs; [
    spotify
    bitwarden-desktop
    modrinth-app
    lutris
    wine
    sbctl
  ]));
}
