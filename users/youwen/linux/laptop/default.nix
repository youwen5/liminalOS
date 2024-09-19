{ pkgs, ... }:
{
  imports = [
    ../theming
    ../home.nix
    ../programs
    ../hyprland/laptop
    ../waybar/laptop
  ];

  # some overrides for laptop specifically
  programs.kitty.settings.font_size = pkgs.lib.mkForce 11;
  programs.neovide.settings.font.size = pkgs.lib.mkForce 12;
}
