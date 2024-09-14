{
  inputs,
  pkgs,
  ...
}:
let
in
# stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
# bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
# nixpkgs-small = inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system};
{
  nixpkgs.overlays = [
    (
      self: super:
      {
      }
    )
  ];
}
