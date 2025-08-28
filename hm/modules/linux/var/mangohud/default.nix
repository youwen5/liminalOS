{
  config,
  osConfig,
  ...
}:
{
  home.file.".config/MangoHud/MangoHud.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${osConfig.functorOS.flakeLocation}/hm/modules/linux/var/mangohud/MangoHud.conf";
}