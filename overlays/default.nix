{
  inputs,
  pkgs,
  ...
}: let
  stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
  bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
in {
  nixpkgs.overlays = [
    (self: super: {
      librewolf = stablepkgs.librewolf;
      manga-tui = bleedingpkgs.manga-tui;
    })
  ];
}
