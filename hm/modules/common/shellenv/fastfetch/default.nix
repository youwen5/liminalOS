{ config, lib, ... }:
let
  fastfetchConfig = builtins.fromJSON (builtins.readFile ./config.json);
  cfg = config.liminalOS.shellEnv.fastfetch;
in
{
  options.liminalOS.shellEnv.fastfetch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.liminalOS.shellEnv.enable;
      description = ''
        Whether to set up and configure fastfetch.
      '';
    };
    useKittyImage = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = ''
        Whether to use the kitty image protocol.
      '';
    };
  };
  config.programs.fastfetch = lib.mkIf cfg.enable {
    enable = true;
    settings = (
      fastfetchConfig
      // {
        logo = {
          height = 18;
          padding = {
            top = 2;
          };
          type = if cfg.useKittyImage then "kitty" else "auto";
          source = lib.mkIf cfg.useKittyImage ./nixos-logo.png;
        };
      }
    );
  };
}
