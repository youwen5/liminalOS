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
    inputs.nur.modules.nixos.default
  ];

  home-manager.extraSpecialArgs = { inherit inputs; };

  # systemd.services.suntheme = {
  #   wantedBy = [ "default.target" ];
  #   after = [
  #     "network.target"
  #     "atd.service"
  #   ];
  #   wants = [ "atd.service" ];
  #   description = "Run suntheme to set daemons";
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = "yes";
  #     ExecStart = ''${inputs.suntheme.packages.${pkgs.system}.default}/bin/suntheme'';
  #   };
  # };
  #
  systemd.services = {
    colorscheme-dawn = {
      description = "Set system colorscheme to dawn";
      unitConfig = {
        ConditionPathExists = [
          "/etc/polarity"
          "/nix/var/nix/profiles/system/specialisation/dawn/bin/switch-to-configuration"
        ];
      };
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        PermissionsStartOnly = true;
        ExecStart = "/nix/var/nix/profiles/system/specialisation/dawn/bin/switch-to-configuration test";
      };
    };
    colorscheme-dusk = {
      description = "Set system colorscheme to dusk";
      unitConfig = {
        ConditionPathExists = [
          "/etc/polarity"
          "/nix/var/nix/profiles/system/bin/switch-to-configuration"
        ];
      };
      serviceConfig = {
        Type = "oneshot";
        User = "root";
        PermissionsStartOnly = true;
        ExecStart = "/nix/var/nix/profiles/system/bin/switch-to-configuration test";
      };
    };
  };
  systemd.timers = {
    colorscheme-dawn = {
      wantedBy = [ "timers.target" ];
      description = "Schedule system colorscheme change to dawn at 7 AM";
      timerConfig = {
        OnCalendar = "*-*-* 07:00:00";
        Persistent = true;
        Unit = "colorscheme-dawn.service";
      };
    };
    colorscheme-dusk = {
      wantedBy = [ "timers.target" ];
      description = "Schedule system colorscheme change to dusk at 6 PM";
      timerConfig = {
        OnCalendar = "*-*-* 18:00:00";
        Persistent = true;
        Unit = "colorscheme-dusk.service";
      };
    };
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.systemd1.manage-units") {
            var unit = action.lookup("unit");

            if (unit == "colorscheme-dawn.service" || unit == "colorscheme-dusk.service") {
                if (subject.active && subject.local) {
                    return polkit.Result.YES;
                } else {
                    return polkit.Result.AUTH_ADMIN_KEEP;
                }
            }
        }
        return polkit.Result.NOT_HANDLED;
    });
  '';

  nix.extraOptions = ''
    !include ${config.age.secrets.nix_config_github_pat.path}
  '';

  nix.settings.trusted-users = [ "youwen" ];

  programs.firefox.nativeMessagingHosts.tridactyl = true;

  fonts.packages = [
    inputs.valkyrie.packages.${pkgs.system}.default
  ];

  liminalOS.theming = {
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

    wallpaper = lib.mkDefault (
      pkgs.fetchurl {
        # url = "https://code.youwen.dev/youwen5/wallpapers/raw/branch/main/anime-with-people/eternal-blue.jpg";
        # url = "https://w.wallhaven.cc/full/rr/wallhaven-rrv23j.jpg";
        # hash = "sha256-PCyWyFgMxVYgDjPMtFbQoMTzN61zdUtiP6Lmgc3dRfk=";
        # hash = "sha256-PcE9TR82IupRl/zqAZ028GMuARAk2CQaU0XUNfw4gkI=";
        url = "https://w.wallhaven.cc/full/ml/wallhaven-mld5v8.png";
        hash = "sha256-I/6A8yOvKYYgPiayn/RJ254nW6JVZ7eKidTZjEJ8xao=";
      }
    );

    # base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/oxocarbon-dark.yaml";
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = lib.mkDefault "dark";
  };

  liminalOS.desktop.localization.chinese.input.enable = true;

  environment.etc.polarity.text = lib.mkDefault "dusk";

  specialisation = {
    dawn.configuration = {
      environment.etc."specialisation".text = "dawn";
      environment.etc.polarity.text = "dawn";
      liminalOS.theming = {
        # wallpaper = pkgs.fetchurl {
        #   url = "https://images.unsplash.com/photo-1545893835-abaa50cbe628?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c2hhbmdoYWl8ZW58MHx8MHx8fDA%3D";
        #   hash = "sha256-QH2CYMSJcfF6bBxpjb/gJImgPbVjSeISB/PuSRLdePs=";
        # };
        wallpaper = "${inputs.wallpapers}/cityscapes/shanghai-the-bund.png";
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon-light.yaml";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-light.yaml";
        polarity = "light";
      };
    };
  };
}
