let
  universalAllowedPorts = [27016 42805];
  universalAllowedRanges = [
    {
      from = 42852;
      to = 42872;
    }
  ];
in {
  services.openssh.enable = true;
  networking.firewall = {
    allowedTCPPorts = universalAllowedPorts;
    allowedUDPPorts = universalAllowedPorts;
    allowedUDPPortRanges = universalAllowedRanges;
    allowedTCPPortRanges = universalAllowedRanges;
  };
  networking.firewall.enable = true;
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
}
