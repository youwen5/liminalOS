{
  imports = [ ./shellenv ];
  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.file.".essentials" = {
    source = ./essentials;
    recursive = true;
  };
}
