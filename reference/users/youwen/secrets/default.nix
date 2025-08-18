{ config, ... }:
{
  age.secrets = {
    youwen_app_password = {
      file = ./youwenw_app_password.age;
      mode = "600";
    };
    youwen_ucsb_client_id = {
      file = ./youwen_ucsb_client_id.age;
      mode = "600";
    };
    youwen_ucsb_client_secret = {
      file = ./youwen_ucsb_client_secret.age;
      mode = "600";
    };
    tincan_app_password = {
      file = ./tincan_app_password.age;
      mode = "600";
    };
    github_cli_secret_config = {
      file = ./github_cli_secret_config.age;
      mode = "600";
      path = "${config.home.homeDirectory}/.config/gh/hosts.yml";
    };
    github_ssh_priv_key = {
      file = ./github_ssh_priv_key.age;
      mode = "600";
    };
    youwen_dev_ssh_priv_key = {
      file = ./youwen_dev_ssh_priv_key.age;
      mode = "600";
    };
    gallium_server_ssh = {
      file = ./gallium_server_ssh.age;
      mode = "600";
    };
    wakatime_cfg = {
      file = ./wakatime_cfg.age;
      mode = "600";
      path = "${config.home.homeDirectory}/.wakatime.cfg";
    };
    code_functor_systems_key = {
      file = ./code_functor_systems_key.age;
      mode = "600";
    };
    youwen_sourcehut_ssh_key = {
      file = ./youwen_sourcehut_ssh_key.age;
      mode = "600";
    };
  };
}
