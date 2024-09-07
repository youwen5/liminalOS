let
  universalAllowedPorts = [
    27016 # grim dawn
    42805 # grim dawn
    42852 # grim dawn
    42872 # grim dawn
    27015 # grim dawn
    27036 # grim dawn

    5173 # vite test server
    4173 # vite test server
  ];
  universalAllowedRanges = [ ];
in
{
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = universalAllowedPorts;
    allowedUDPPorts = universalAllowedPorts;
    allowedUDPPortRanges = universalAllowedRanges ++ [
      {
        from = 27031;
        to = 27036;
      }
    ];
    allowedTCPPortRanges = universalAllowedRanges;
  };

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
}
