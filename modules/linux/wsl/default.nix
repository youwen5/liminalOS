{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "youwen";
    useWindowsDriver = true;
  };
}
