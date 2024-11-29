{
  kitty ? true,
}:
{ config, ... }:
let
  fastfetchConfig = builtins.fromJSON (builtins.readFile ./config.json);
in
{
  # home.file.".config/fastfetch/config.jsonc".source = ./config.jsonc;
  programs.fastfetch = {
    enable = true;
    settings = (
      fastfetchConfig
      // {
        logo.type = if kitty == "cassini" then "auto" else "kitty";
        logo.source = ./nixos-logo.png;
      }
    );
  };
}
