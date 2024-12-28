{ pkgs, ... }:
{
  users.users.youwen = {
    isNormalUser = true;
    description = "Youwen Wu";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
    initialHashedPassword = "$y$j9T$v0OkEeCntj8KwgPJQxyWx0$dx8WtFDYgZZ8WE3FWetWwRfutjQkznRuJ0IG3LLAtP2";
  };
}
