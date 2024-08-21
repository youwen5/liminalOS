{inputs, ...}: {
  nixpkgs.overlays = [
    (self: super: {
      typst-lsp = inputs.stablepkgs.legacyPackages.${self.system}.typst-lsp;
    })
  ];
}
