{
  pkgs,
  inputs,
  ...
}:
let
  createCommon = import ../common-packages.nix;
in
{
  home.packages =
    (createCommon pkgs)
    ++ (with pkgs; [
      bitwarden-desktop
      modrinth-app
      lutris
      sbctl
      r2modman
      zoom-us
    ]);

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.zen-browser}/bin/zen";
  };
}
