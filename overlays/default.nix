{
  inputs,
  pkgs,
  ...
}: let
  stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
  bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
  nixpkgs-small = inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system};
in {
  nixpkgs.overlays = [
    (self: super: {
      manga-tui = bleedingpkgs.manga-tui;
    })
    # inputs.zen-browser.overlays.default
  ];
}
