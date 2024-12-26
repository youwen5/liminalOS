{
  liminalSystemModules,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.wsl;
in
{
  imports = [
    liminalSystemModules.nixos-wsl.nixosModules.default
  ];

  options.liminalOS.wsl = {
    enable = lib.mkEnableOption "WSL";
  };

  config.wsl = lib.mkIf cfg.enable {
    enable = true;
    defaultUser = config.liminalOS.username;
    useWindowsDriver = true;
  };
}
