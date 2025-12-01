{
  config,
  namespace,
  lib,
  options,
  ...
}: {
  options.${namespace}.network.adguardhome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AdGuard Home service.";
    };
    settings = options.services.adguardhome.settings;
  };
  config = lib.mkIf config.${namespace}.network.adguardhome.enable {
    services.adguardhome = {
      enable = false;
      mutableSettings = true;
      settings = config.${namespace}.network.adguardhome.settings;
    };
  };
}
