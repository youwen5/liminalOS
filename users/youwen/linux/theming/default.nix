{ pkgs, ... }:
{
  # imports = [ ./catppuccin.nix ];
  #
  imports = [ ./stylix.nix ];

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    # theme = {
    #   name = "rose-pine";
    #   package = pkgs.rose-pine-gtk-theme;
    # };
  };

  # qt = {
  #   enable = true;
  #   platformTheme.name = "gtk";
  #   style.name = "gtk2";
  # };

  # home.file.".config/kdeglobals".text = ''
  #   [Colors:View]
  #   BackgroundNormal=#191724
  # '';
}
