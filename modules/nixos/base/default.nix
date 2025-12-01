{
  lib,
  namespace,
  ...
}: {
  options.${namespace}.base = {
    enable = lib.mkEnableOption "Enable base components";
  };
  config = {};
}
