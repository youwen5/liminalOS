{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    inputs.viminal.packages.${pkgs.system}.default
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
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    # Free up to 1GiB when there is less than 100MiB left
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };
}
