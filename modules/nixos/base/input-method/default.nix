{
  namespace,
  lib,
  config,
  ...
}: let
  inherit (config.${namespace}.base) input-method;
in {
  options.${namespace}.base.input-method = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable input method support.";
    };
    addons = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional input method packages to install.";
    };
  };
  config = lib.mkIf input-method.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = input-method.addons;
        waylandFrontend = true;
      };
    };
  };
}
