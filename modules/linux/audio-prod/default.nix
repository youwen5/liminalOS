{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    reaper
    yabridge
    yabridgectl
  ];
}
