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
    (self: super: {
      zen-browser =
        if system == "x86_64-linux" then
          inputs.zen-browser.packages.${system}.default
        else if system == "aarch64-linux" then
          inputs.zen-browser-source.packages.${system}.default
        else
          null;
    })
  ];
}
