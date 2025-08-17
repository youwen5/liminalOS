{ pkgs, ... }:
{
  users.users.youwen = {
    isNormalUser = true;
    description = "Youwen Wu";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.nushell;
    initialHashedPassword = "";
  };
}
