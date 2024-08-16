{pkgs, ...}: let
  createCommon = import ../common-packages.nix;
in {home.packages = (createCommon pkgs) ++ [];}
