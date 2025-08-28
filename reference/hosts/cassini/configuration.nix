# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}:
{
  networking.hostName = "cassini"; # Define your hostname.

  functorOS = {
    flakeLocation = "/home/youwen/.config/functorOS";
    defaultEditor = inputs.viminal.packages.${pkgs.system}.default;
    formFactor = "desktop";
    theming = {
      wallpaper = "${inputs.wallpapers}/aesthetic/afterglow_city_skyline_at_night.png";
      # if you don't manually set polarity when using manual colorscheme, GTK
      # apps won't respect colorscheme
      base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
      polarity = "dark";
    };
    system = {
      networking.enable = false;
    };
    wsl.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.youwen = {
    isNormalUser = true;
    description = "Youwen Wu";
  };

  nix.settings = {
    trusted-users = [
      "root"
      "youwen"
    ];
  };

  nixpkgs.hostPlatform = "x86_64-linux";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}