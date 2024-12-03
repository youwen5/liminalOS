{
  inputs,
  pkgs,
  config,
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
    optimise.automatic = true;
    # gc = {
    #   automatic = true;
    #   dates = "weekly";
    #   options = "--delete-older-than 14d";
    # };
    # Free up to 1GiB when there is less than 100MiB left
    extraOptions = ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
      ];
    };
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/youwen/.config/liminalOS";
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  boot.tmp.cleanOnBoot = true;
}
