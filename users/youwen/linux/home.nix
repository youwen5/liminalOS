{
  inputs,
  pkgs,
  osConfig,
  config,
  ...
}:
{
  home.username = "youwen";
  home.homeDirectory = "/home/youwen";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # home.file.".wallpapers" = {
  #   source = inputs.wallpapers;
  #   recursive = true;
  # };
  #
  # home.file.".config/easyeffects/input" = {
  #   source = ./easyeffects/input;
  #   recursive = true;
  # };

  # home.file.".config/easyeffects/output" = {
  #   source = ./easyeffects/output;
  #   recursive = true;
  # };
  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.

  # Audio effects and EQ tool
  services.easyeffects.enable = true;
  services.easyeffects.package = pkgs.easyeffects;

  programs.spotify-player.enable = true;

  # Notification daemon
  # services.dunst = {
  #   enable = true;
  #   # catppuccin.enable = true;
  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #     size = "32x32";
  #   };
  # };

  # Currently non-functional
  programs.wlogout.enable = true;
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    # theme = "gruvbox-dark";
    terminal = "${pkgs.kitty}/bin/kitty";
    extraConfig = {
      modi = "window,drun,ssh,combi,filebrowser,recursivebrowser";
      display-drun = " 󰘧 ";
      combi-modi = "window,drun,ssh";
      run-shell-command = "{terminal} -e {cmd}";
      sidebar-mode = true;
      background-color = "transparent";
      sorting = "fuzzy";
    };
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish.functions = {
    # rebuild = ''doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} switch &| nom'';
    # os-test = ''doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} test &| nom'';
    # nixos-update = ''
    #   cd ~/.config/liminalOS
    #   nix flake update --commit-lock-file
    #   doas nixos-rebuild --flake ~/.config/liminalOS\#${osConfig.networking.hostName} switch &| nom
    # '';
    nh = {
      # wrapper for nh as it doesn't work with `doas`
      body = ''
        if count $argv > /dev/null
          if contains -- os $argv or contains -- clean $argv
            doas ${pkgs.nh}/bin/nh $argv -R
          else
            ${pkgs.nh}/bin/nh $argv
          end
        else
            ${pkgs.nh}/bin/nh
        end
      '';
    };
    spt = "${pkgs.spotify-player}/bin/spotify_player";
  };

  home.file = {
    ".config/vesktop/settings.json".source = config.lib.file.mkOutOfStoreSymlink ./var/settings.json;
    ".config/easyeffects/output" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/liminalOS/users/youwen/linux/var/easyeffects/output";
      recursive = true;
    };
    ".config/easyeffects/input" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/liminalOS/users/youwen/linux/var/easyeffects/input";
      recursive = true;
    };
  };
}
