rec {
  users = builtins.attrValues {
    "youwen@demeter" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwqDFdb/cs5K9gsgP0ogyuq5pv9hSxsyPnDcWc5wRKs";
    "youwen@callisto" =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA+0w7l4jWN+b3Cqs9pjzjxUt2tRXk8HPIB3sqfUQMdx";
    runner = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEEBFBqlbHn3gMuV0i8U48xctZUWXkmHsCK1O6LRpXpj";
  };

  systems = builtins.attrValues {
    demeter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP4BRdoxPnmlhMD1kI7qXwVE//6h1XWUnkwpzDuJaAyC";
    gallium = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzDKscmZIz7GF0nfKpnKHq63/fwzx2PXir0mUtRDOgu";
    callisto = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7CqpsBe6+pAQa5CC8m2quJdDg6hRCJlTbVEcHN2xxV";
  };

  all = users ++ systems;
}
