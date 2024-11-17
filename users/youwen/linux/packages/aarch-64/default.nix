{ inputs, pkgs, ... }:
let
  createCommon = import ../common-packages.nix;
in
{
  home.packages =
    (createCommon pkgs)
    ++ [
    ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.zen-browser}/bin/zen";
  };
}
