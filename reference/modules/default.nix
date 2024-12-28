{ config, ... }:
{
  nix.extraOptions = ''
    !include ${config.age.secrets.nix_config_github_pat.path}
  '';
}
