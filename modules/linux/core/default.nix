{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.personal-neovim.packages.${pkgs.system}.default
  ];

  security.sudo.enable = false;

  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "youwen" ];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  services.gnome.gnome-keyring.enable = true;

  nix = {
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
