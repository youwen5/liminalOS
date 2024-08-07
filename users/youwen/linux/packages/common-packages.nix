pkgs:
with pkgs; [
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

  # system tools
  pciutils # lspci
  usbutils # lsusb

  # desktop utils
  wl-clipboard
  grim
  slurp
  swappy
  pavucontrol
  swww
  waypaper

  # desktop apps
  dolphin
  thunderbird
  vesktop
  signal-desktop

  # dev tools
  nodePackages_latest.pnpm
  rustfmt
  rust-analyzer

  # desktop ricing
  bibata-cursors
  libsForQt5.qtstyleplugin-kvantum
  libsForQt5.qt5ct
  papirus-icon-theme
  libsForQt5.qt5ct
]