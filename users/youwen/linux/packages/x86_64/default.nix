{
  pkgs,
  inputs,
  ...
}: let
  createCommon = import ../common-packages.nix;
in {
  home.packages =
    (createCommon pkgs)
    ++ (with pkgs; [
      bitwarden-desktop
      modrinth-app
      lutris
      wine
      sbctl
      r2modman
      inputs.zen-browser.packages.${pkgs.system}.specific
    ]);
}
