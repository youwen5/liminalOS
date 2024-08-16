{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif"];
        sansSerif = ["Noto Sans"];
      };
    };
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["CascadiaCode"];})
      (google-fonts.override {fonts = ["Lora"];})
    ];
  };
}
