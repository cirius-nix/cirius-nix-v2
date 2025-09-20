{
  config,
  namespace,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.${namespace}) mkEnumOption;
  inherit (config.${namespace}.base) file-manager;
in
{
  options.${namespace}.base.file-manager = {
    name = mkEnumOption [ "nautilus" "nnn" ] "nnn" "Default file manager";
  };
  config = lib.mkIf config.${namespace}.base.enable {
    environment.systemPackages = [
      pkgs.${file-manager.name}
    ];
  };
}
