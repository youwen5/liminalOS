let
  keys = import ../authorized_keys.nix;
in
{
  "nix_config_github_pat.age".publicKeys = keys.all;
  "github_ssh_priv_key.age".publicKeys = keys.all;
}
