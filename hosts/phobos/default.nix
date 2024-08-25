{inputs, ...}: {
  imports = with inputs; [
    ./configuration.nix
    home-manager.darwinModules.home-manager
    {
      extraSpecialArgs = {inherit inputs;};
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.youwen.imports = [
        ../../users/youwen/darwin/darwin-home.nix
        ../../users/youwen/common/core.nix
        ../../users/youwen/common/neofetch
      ];
      home-manager.backupFileExtension = "backup";
    }
    nix-homebrew.darwinModules.nix-homebrew
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/yabai.nix
    ../../modules/darwin/skhd.nix
  ];
}
