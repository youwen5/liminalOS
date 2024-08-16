{
  services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];
}
