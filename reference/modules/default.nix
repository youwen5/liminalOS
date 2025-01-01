{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ../secrets/nixos
    ../users/youwen/nixos.nix
  ];

  nix.extraOptions = ''
    !include ${config.age.secrets.nix_config_github_pat.path}
  '';

  nix.settings.trusted-users = [ "youwen" ];

  liminalOS.theming = lib.mkDefault {
    # wallpaper = "${inputs.wallpapers}/aesthetic/afterglow_city_skyline_at_night.png";
    # wallpaper = "${
    #   pkgs.fetchFromGitHub {
    #     owner = "dharmx";
    #     repo = "walls";
    #     rev = "6bf4d733ebf2b484a37c17d742eb47e5139e6a14";
    #     hash = "sha256-YdPkJ+Bm0wq/9LpuST6s3Aj13ef670cQOxAEIhJg26E=";
    #     sparseCheckout = [ "radium" ];
    #   }
    # }/radium/a_mountain_range_at_night.png";
    wallpaper = pkgs.fetchurl {
      url = "https://code.youwen.dev/youwen5/wallpapers/raw/branch/main/anime-with-people/eternal-blue.jpg";
      hash = "sha256-PCyWyFgMxVYgDjPMtFbQoMTzN61zdUtiP6Lmgc3dRfk=";
    };

    # if you don't manually set polarity when using manual colorscheme, GTK
    # apps won't respect colorscheme
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    polarity = "dark";
  };
}
