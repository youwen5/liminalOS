{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.functorOS.wsl;
in
{
  options.functorOS.wsl = {
    enable = lib.mkEnableOption "WSL";
  };

  config.wsl = lib.mkIf cfg.enable {
    enable = true;
    defaultUser = config.functorOS.username;
    useWindowsDriver = true;
  };
}