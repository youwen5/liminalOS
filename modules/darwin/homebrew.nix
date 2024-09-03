{ inputs, ... }:
{
  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "youwen";

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    mutableTaps = false;
  };
}
