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
    ++ (
      with pkgs;
      [
        bitwarden-desktop
        modrinth-app
        lutris
        wine
        sbctl
        r2modman
      ]
      ++ [ zen-browser ]
    );

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
    };
  };

  home.sessionVariables = {
    DEFAULT_BROWSER = "${zen-browser}/bin/zen";
  };
}
