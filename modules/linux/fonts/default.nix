{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.system.fonts;
in
{
  options.liminalOS.system.fonts = {
    enable = lib.mkEnableOption "fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages =
        with pkgs;
        [
          noto-fonts-cjk-sans
          (google-fonts.override { fonts = [ "Lora" ]; })
        ]
        ++ (lib.optionals (!config.liminalOS.theming.enable) [
          noto-fonts
          noto-fonts-emoji
          nerd-fonts.caskaydia-cove
        ]);
    };
  };
}
