{
  namespace,
  lib,
  config,
  ...
}:
let
  inherit (config.${namespace}.base) input-method;
in
{
  options.${namespace}.base.input-method = {
    addons = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional input method packages to install.";
    };
  };
  config = {
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
