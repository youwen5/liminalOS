{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    winetricks
    wine
  ];
  nixpkgs.overlays = [
    (self: super: {
      wine = super.wineWowPackages.stable;
    })
  ];
}
