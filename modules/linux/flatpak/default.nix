# NOTE: this module is IMPURE. Flatpaks are declaratively specified but not
# versioned. Therefore, they are not included in generational rollbacks and
# persist between generations. This is not ideal, but at least it is a better
# situation than imperative installation
{ inputs, ... }:
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = {
    enable = true;

    overrides = {
      global = {
        Context.sockets = [
          "wayland"
          "!x11"
          "!fallback-x11"
        ];

        Environment = {
          # Fix un-themed cursor in some Wayland apps
          XCURSOR_PATH = "/run/host/user-share/icons:/run/host/share/icons";
        };
      };
    };

    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    packages = [
      {
        flatpakref = "https://sober.vinegarhq.org/sober.flatpakref";
        sha256 = "sha256:1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l";
      }
      {
        appId = "org.vinegarhq.Sober";
        origin = "sober";
      }
    ];
  };
}
