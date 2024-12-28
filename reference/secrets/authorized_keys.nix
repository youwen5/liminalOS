rec {
  users = builtins.attrValues {
    youwen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwqDFdb/cs5K9gsgP0ogyuq5pv9hSxsyPnDcWc5wRKs";
    runner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEBFBqlbHn3gMuV0i8U48xctZUWXkmHsCK1O6LRpXpj";
  };

  systems = builtins.attrValues {
    demeter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4BRdoxPnmlhMD1kI7qXwVE//6h1XWUnkwpzDuJaAyC";
    gallium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzDKscmZIz7GF0nfKpnKHq63/fwzx2PXir0mUtRDOgu";
  };

  all = users ++ systems;
}
