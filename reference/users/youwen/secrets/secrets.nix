let
  keys = import ../../../secrets/authorized_keys.nix;
  inherit (keys) users;
in
{
  "youwenw_app_password.age".publicKeys = users;
  "youwen_ucsb_client_id.age".publicKeys = users;
  "youwen_ucsb_client_secret.age".publicKeys = users;
  "tincan_app_password.age".publicKeys = users;
  "github_cli_secret_config.age".publicKeys = users;
  "github_ssh_priv_key.age".publicKeys = users;
  "youwen_dev_ssh_priv_key.age".publicKeys = users;
  "gallium_server_ssh.age".publicKeys = users;
  "wakatime_cfg.age".publicKeys = users;
  "code_functor_systems_key.age".publicKeys = users;
  "youwen_sourcehut_ssh_key.age".publicKeys = users;
}
