{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.functorOS;
in
{
  imports = [
    ./linux
    ../hm
  ];
  options.functorOS = {
    darwin.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable functorOS's default modules and options for Darwin.
      '';
    };
  };
}