{
  age.secrets = {
    youwen_app_password = {
      file = ./youwenw_app_password.age;
      owner = "youwen";
      group = "users";
      mode = "600";
    };
    youwen_ucsb_client_id = {
      file = ./youwen_ucsb_client_id.age;
      owner = "youwen";
      group = "users";
      mode = "600";
    };
    youwen_ucsb_client_secret = {
      file = ./youwen_ucsb_client_secret.age;
      owner = "youwen";
      group = "users";
      mode = "600";
    };
    tincan_app_password = {
      file = ./tincan_app_password.age;
      owner = "youwen";
      group = "users";
      mode = "600";
    };
    github_cli_secret_config = {
      file = ./github_cli_secret_config.age;
      owner = "youwen";
      group = "users";
      mode = "600";
      path = "/home/youwen/.config/gh/hosts.yml";
    };
  };
}
