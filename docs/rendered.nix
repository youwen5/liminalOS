{
  docs-raw,
  title,
  pandoc,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  name = "docs";

  phases = [
    "buildPhase"
    "installPhase"
  ];

  nativeBuildInputs = [
    pandoc
  ];

  buildPhase = ''
    pandoc -s ${docs-raw} -o index.html --metadata title="${title}"
  '';

  installPhase = ''
    mkdir -p $out
    cp index.html $out/index.html
  '';
}
