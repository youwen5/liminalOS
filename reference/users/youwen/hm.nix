{ config, ... }:
{

  imports = [
    ./secrets
    ./neomutt.nix
  ];

  home = {
    username = "youwen";
    homeDirectory = "/home/youwen";
  };

  liminalOS = {
    utils.easyeffects.enable = true;
  };

  programs.git = {
    userName = "Youwen Wu";
    userEmail = "youwenw@gmail.com";
    signing = {
      signByDefault = true;
      key = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "code.youwen.dev" = {
        host = "code.youwen.dev";
        # port = 222;
        identityFile = config.age.secrets.youwen_dev_ssh_priv_key.path;
      };
      "github" = {
        host = "github.com";
        identityFile = config.age.secrets.github_ssh_priv_key.path;
      };
      "gallium" = {
        host = "gallium";
        port = 222;
        identityFile = config.age.secrets.gallium_server_ssh.path;
      };
    };
  };
}
