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
    ])
    ++ (lib.optionals cfg.firewallPresets.terraria [
      7777
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
      terraria = lib.mkEnableOption "firewall ports for Terraria";
    };
    cloudflareNameservers.enable = lib.mkEnableOption "Cloudflare DNS servers";
    backend = lib.mkOption {
      type = lib.types.enum [
        "wpa_supplicant"
        "iwd"
      ];
      default = "wpa_supplicant";
      description = ''
        Which backend to use for networking. Default is wpa_supplicant with NetworkManager as a frontend. With iwd, iwctl is the frontend.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;

    networking.nftables = {
      enable = true;
      ruleset = ''
        define EXCLUDED_IPS = {
          101.6.15.130
        }

        table inet excludeTraffic {
          chain excludeOutgoing {
            type route hook output priority 0; policy accept;
            ip daddr $EXCLUDED_IPS ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
          }
        }
      '';
    };

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

    networking.networkmanager.enable = lib.mkIf (cfg.enable && cfg.backend == "wpa_supplicant") true;

    systemd.services.NetworkManager-wait-online.enable = lib.mkIf (
      cfg.enable && cfg.backend == "wpa_supplicant"
    ) false;

    networking.wireless.iwd = lib.mkIf (cfg.enable && cfg.backend == "iwd") {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
      settings.Rank.BandModifier5GHz = 2.0;
    };

  };
}
