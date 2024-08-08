{ inputs, config, pkgs, ... }:

{
  home.username = "youwen";
  home.homeDirectory = "/Users/youwen";

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

  home.file.".config/neofetch/config.conf".source = ../../../config/neofetch.conf;
  
  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    neofetch

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    nurl # helps fetch git data for nixpkgs

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # dev tools
    nodePackages_latest.pnpm
    rustfmt
    rust-analyzer
  ];

  programs.git.extraConfig.commit.gpgsign = "false";

  programs.oh-my-posh.enableZshIntegration = true;

  programs.bash.enable = true;
  programs.zsh.enable = true;

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night";
    font.name = "CaskaydiaCove Nerd Font";
    settings = {
      font_size = 13;
      window_padding_width = "8 8 0";
      confirm_os_window_close = -1;
      shell_integration = "enabled";
      enable_audio_bell = "no";
      background_opacity = "0.8";
      hide_window_decorations = "titlebar-only";
      background_blur = 32;
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  home.stateVersion = "24.05";
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

}
