{ inputs, config, pkgs, ... }: {
  # Expose the package set, including overlays, for convenience.
  darwinPackages = inputs.self.darwinConfigurations."Youwens-MacBook-Pro".pkgs;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [ ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnfree = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  programs.fish.enable = true;
  programs.bash.enable = true;

  system.configurationRevision =
    config.self.rev or config.self.dirtyRev or null;

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.users.youwen = {
    home = "/Users/youwen";
    description = "Youwen Wu";
    shell = pkgs.fish;
  };

  security.pam.enableSudoTouchIdAuth = true;

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      (google-fonts.override { fonts = [ "Lora" ]; })
    ];
  };
}
