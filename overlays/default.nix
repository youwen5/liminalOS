{inputs, ...}: {
  nixpkgs.overlays = [
    (self: super: {
      librewolf = inputs.stablepkgs.${self.system}.librewolf;
    })
  ];
}
