{
  inputs,
  pkgs,
  ...
}:
let
  # bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
  inherit (pkgs) system;
in
# stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
# nixpkgs-small = inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system};
{
  nixpkgs.overlays = [
    (import ../pkgs { inherit pkgs; })
    (self: super: {
      zen-browser = inputs.zen-browser.packages.${system}.default;
      zen-browser-unwrapped = inputs.zen-browser.packages.${system}.zen-browser-unwrapped;
    })
  ];
}
