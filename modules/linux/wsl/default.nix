{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.liminalOS.wsl;
in
{
  imports = lib.mkIf cfg.enable [
    inputs.nixos-wsl.nixosModules.default
  ];

  options = {
    enable = lib.mkEnableOption "wsl";
    module = lib.mkOption {
      type = lib.types.submodule;
      default = inputs.nixos-wsl.nixosModules.default;
      description = ''
        NixOS WSL module. Defaults to <https://github.com/nix-community/NixOS-WSL>
      '';
    };
  };

  config.wsl = lib.mkIf cfg.enable {
    enable = true;
    defaultUser = config.liminalOS.username;
    useWindowsDriver = true;
  };
}
