{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "ModrinthApp";
  version = "0.9.2";
  src = fetchurl {
    url = "https://launcher-files.modrinth.com/versions/${version}/linux/Modrinth%20App_${version}_amd64.AppImage";
    hash = "sha256-lL2FVNeb/IUNFC/BjWNOk3cDIxY2f+eQj0QcnHxwVfw=";
  };
  appimageContents = appimageTools.extractType1 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname src version;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/256x256@2/apps
    mkdir -p $out/share/icons/hicolor/128x128/apps

    ln -s ${appimageContents}/'Modrinth App.desktop' $out/share/applications
    ln -s ${appimageContents}/ModrinthApp.png $out/share/icons/hicolor/256x256@2/apps/ModrinthApp.png
    ln -s ${appimageContents}/ModrinthApp.png $out/share/icons/hicolor/128x128/apps/ModrinthApp.png
  '';

  meta = {
    description = "Modrinth's game launcher";
    longDescription = ''
      A unique, open source launcher that allows you to play your favorite mods,
      and keep them up to date, all in one neat little package
    '';
    homepage = "https://modrinth.com";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "ModrinthApp";
    platforms = [ "x86_64-linux" ];
  };
}
