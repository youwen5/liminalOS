let
  universalAllowedPorts = [
    27016 # grim dawn
    42805 # grim dawn
    5173 # vite test server
    4173 # vite test server
  ];
  universalAllowedRanges = [
    {
      from = 42852;
      to = 42872;
    }
  ];
in
{
  services.openssh.enable = true;
  networking.firewall = {
    allowedTCPPorts = universalAllowedPorts;
    allowedUDPPorts = universalAllowedPorts;
    allowedUDPPortRanges = universalAllowedRanges;
    allowedTCPPortRanges = universalAllowedRanges;
  };
  networking.firewall.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];
}
