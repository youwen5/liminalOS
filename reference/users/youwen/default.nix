{
  imports = [
    ../../../hm/modules
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
}
