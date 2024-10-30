{ pkgs, ... }:
{
  home.file.".config/fastfetch/config.jsonc".source = ./config.jsonc;
  home.file.".local/share/fastfetch/images/nixos-logo.png".source = ./nixos-logo.png;
  programs.fastfetch = {
    enable = true;
  };

  home.packages = [
    (pkgs.writeShellScriptBin "neofetch" "${pkgs.fastfetch}/bin/fastfetch")
  ];
}
