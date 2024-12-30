{
  lib,
  stdenv,
  wine,
  pkgsCross,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wine-discord-ipc-bridge";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "0e4ef622";
    repo = "wine-discord-ipc-bridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jzsbOKMakNQ6RNMlioX088fGzFBDxOP45Atlsfm2RKg=";
  };

  nativeBuildInputs = [
    pkgsCross.mingw32.stdenv.cc
    wine
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp winediscordipcbridge.exe $out/bin
    cp winediscordipcbridge-steam.sh $out/bin
  '';

  meta = {
    description = "Enable games running under wine to use Discord Rich Presence";
    homepage = "https://github.com/0e4ef622/wine-discord-ipc-bridge";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
})
