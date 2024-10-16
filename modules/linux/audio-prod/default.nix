{ pkgs, ... }:
{
  imports = [
    ../wine
  ];
  environment.systemPackages = with pkgs; [
    reaper
    yabridge
    yabridgectl
  ];
}
