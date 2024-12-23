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
  imports = [
    inputs.${cfg.wslName}.nixosModules.default
  ];

  options = {
    enable = lib.mkEnableOption "WSL";
    wslName = lib.mkOption {
      type = lib.types.str;
      default = "nixos-wsl";
      description = ''
        Name of the NixOS WSL module in your flake inputs. You should define `inputs.nixos-wsl.url = "github:nixos-community/nixos-wsl", and set `liminalOS.wsl.wslName` if you did not call it `nixos-wsl`.
      '';
    };
  };

  config.wsl = lib.mkIf cfg.enable {
    enable = true;
    defaultUser = config.liminalOS.username;
    useWindowsDriver = true;
  };
  assertions = [
    {
      assertion = builtins.hasAttr cfg.wslName inputs;
      message = ''You enabled WSL but did not add the WSL module to your flake inputs, or did not set `liminalOS.theming.wslName` to the name of your NixOS WSL input, if it is not `nixos-wsl`. Please set `inputs.nixos-wsl.url = "github:nix-community/nixos-wsl"` or set the wslName option to the name of your WSL flake input.'';
    }
  ];
}
