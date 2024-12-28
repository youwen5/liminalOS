{
  age.secrets = {
    nix_config_github_pat = {
      file = ./nix_config_github_pat.age;
      owner = "youwen";
      group = "users";
      mode = "0440";
    };
    # github_ssh_priv_key = {
    #   file = ./github_ssh_priv_key.age;
    #   mode = "600";
    #   owner = "root";
    #   # path = "${config.home.homeDirectory}/.ssh/github_ssh_priv_key";
    # };
  };
}
