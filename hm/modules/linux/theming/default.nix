{ pkgs, ... }:
{
  imports = [ ./stylix.nix ];
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
    };
  };
}
