{pkgs, ...}: {
  imports = [./catppuccin.nix];

  gtk = {
    enable = true;
    catppuccin.enable = true;
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      size = 26;
    };
    iconTheme = {name = "Papirus-Dark";};
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile = {
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=GraphiteNordDark
    '';

    "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  };
}
