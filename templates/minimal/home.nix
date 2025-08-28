{ inputs, ... }:
{
  imports = [
    # import the functorOS home manager module
    inputs.functorOS.homeManagerModules.default
  ];

  home = {
    username = "default-user";
    homeDirectory = "/home/default-user";
  };

  functorOS = {
    # Enable the easyeffects program to easily EQ your headphones and add
    # microphone effects
    utils.easyeffects.enable = true;
  };

  programs.git = {
    userName = "Default User";
    userEmail = "default@localhost";
  };

  home.stateVersion = "24.05";
}