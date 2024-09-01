{
  inputs,
  pkgs,
  ...
}: let
  stablepkgs = inputs.stablepkgs.legacyPackages.${pkgs.system};
  bleedingpkgs = inputs.bleedingpkgs.legacyPackages.${pkgs.system};
  nixpkgs-small = inputs.nixpkgs-unstable-small.legacyPackages.${pkgs.system};
  fetchpatch = pkgs.fetchpatch;
in {
  nixpkgs.overlays = [
    (self: super: {
      # manga-tui = inputs.manga-tui.packages.${pkgs.system}.default;
      xdg-desktop-portal-hyprland = super.xdg-desktop-portal-hyprland.overrideAttrs (oldAttrs: {
        src = oldAttrs.src;
        patches =
          oldAttrs.patches
          or []
          ++ [
            # removes wayland-scanner from deps, as it includes a pkg-config that
            # defines that it has a non-existent include directory which trips up CMake
            (fetchpatch {
              url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/5555f467f68ce7cdf1060991c24263073b95e9da.patch";
              hash = "sha256-yNkg7GCXDPJdsE7M6J98YylnRxQWpcM5N3olix7Oc1A=";
            })
            (fetchpatch {
              url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/0dd9af698b9386bcf25d3ea9f5017eca721831c1.patch";
              hash = "sha256-Y6eWASHoMXVN2rYJ1rs0jy2qP81/qbHsZU+6b7XNBBg=";
            })
            # handle finding wayland-scanner more nicely
            (fetchpatch {
              url = "https://github.com/hyprwm/xdg-desktop-portal-hyprland/commit/2425e8f541525fa7409d9f26a8ffaf92a3767251.patch";
              hash = "sha256-6dCg/U/SIjtvo07Z3tn0Hn8Xwx72nwVz6Q2cFnObonU=";
            })
          ];
      });
    })
  ];
}
