{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS;
in
{
  imports = [
    ./linux
    ../hm
  ];
  options.liminalOS = {
    darwin.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable liminalOS's default modules and options for Darwin.
      '';
    };
  };
}
