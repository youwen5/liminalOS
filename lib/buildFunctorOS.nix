{
  nixpkgs,
  inputs,
  systemModule,
}:
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs;
  };
  modules = [
    systemModule
  ];
}
