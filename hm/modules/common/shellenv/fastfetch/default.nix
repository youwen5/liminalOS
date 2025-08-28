{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  fastfetchConfig = builtins.fromJSON (builtins.readFile ./config.json);
  cfg = config.functorOS.shellEnv.fastfetch;
in
{
  options.functorOS.shellEnv.fastfetch = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.functorOS.shellEnv.enable;
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
    tintImage = lib.mkOption {
      type = lib.types.bool;
      default = osConfig.functorOS.theming.enable;
      description = ''
        Whether to tint the image with system wide colors.
      '';
    };
  };
  config.programs.fastfetch =
    let
      image =
        if !cfg.tintImage then
          ./nixos-logo.png
        else
          pkgs.runCommand "nixos-logo.png" { } ''
            COLOR="#${config.lib.stylix.colors.base0A}"
            ${lib.getExe pkgs.imagemagick} ${./nixos-logo.png} -size 512x512 -fill $COLOR -tint 50 $out
          '';
    in
    lib.mkIf cfg.enable {
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
            source = lib.mkIf cfg.useKittyImage image;
          };
        }
      );
    };
}