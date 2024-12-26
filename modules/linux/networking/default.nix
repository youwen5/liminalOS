{ lib, config, ... }:
let
  cfg = config.liminalOS.system.networking;

  universalAllowedPorts =
    (lib.optionals cfg.firewallPresets.grimDawn [
      27016 # grim dawn
      42805 # grim dawn
      42852 # grim dawn
      42872 # grim dawn
      27015 # grim dawn
      27036 # grim dawn
    ])
    ++ (lib.optionals cfg.firewallPresets.vite [
      5173 # vite test server
      4173 # vite test server
    ]);
  universalAllowedRanges = [ ];
in
{
  options.liminalOS.system.networking = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.enable;
      description = ''
        Whether to enable networking features.
      '';
    };
    firewallPresets = {
      grimDawn = lib.mkEnableOption "firewall ports for Grim Dawn";
      vite = lib.mkEnableOption "firewall ports for Vite";
    };
    cloudflareNameservers.enable = lib.mkEnableOption "Cloudflare DNS servers";
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;

    networking.firewall = {
      enable = true;
      allowedTCPPorts = universalAllowedPorts;
      allowedUDPPorts = universalAllowedPorts;
      allowedUDPPortRanges =
        universalAllowedRanges
        ++ (lib.optionals cfg.firewallPresets.grimDawn [
          {
            from = 27031;
            to = 27036;
          }
        ]);
      allowedTCPPortRanges = universalAllowedRanges;
    };

    networking.nameservers = lib.mkIf cfg.cloudflareNameservers.enable [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
