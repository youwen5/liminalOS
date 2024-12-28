{ config, ... }:
{
  imports = [
    ../secrets/nixos
    ../users/youwen/nixos.nix
  ];

  nix.extraOptions = ''
    !include ${config.age.secrets.nix_config_github_pat.path}
  '';
}
