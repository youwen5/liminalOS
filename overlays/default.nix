{
  inputs,
  pkgs,
  ...
}:
let
  bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
in
# stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
# nixpkgs-small = inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system};
{
  nixpkgs.overlays = [
    (self: super: {
      _7zz = bleedingpkgs._7zz;
    })
  ];
}
