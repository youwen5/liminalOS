pkgs: with pkgs; [
  # archives
  zip
  xz
  unzip
  p7zip

  # utils
  nurl # helps fetch git data for nixpkgs
  ffmpeg

  # nix related
  #
  # it provides the command `nom` works just like `nix`
  # with more details log output
  nix-output-monitor

  # system tools
  pciutils # lspci
  usbutils # lsusb

  # desktop utils
  # bitwarden-cli

  # desktop apps
  xfce.thunar
  thunderbird

  # messengers
  signal-desktop
  iamb
  discordo

  # fun
  ani-cli
  manga-tui

  gcc

  hledger
]
