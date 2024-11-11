{
  pkgs,
  inputs,
  ...
}:
let
  createCommon = import ../common-packages.nix;
  zen-browser = inputs.zen-browser.packages.${pkgs.system}.specific;
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
    DEFAULT_BROWSER = "${zen-browser}/bin/zen";
  };
}
