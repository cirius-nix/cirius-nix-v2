{...}: {
  pantheon = {
    applyAttrOnEnabled = {
      pkgs,
      osConfig ? {},
      namespace,
      ...
    }: module:
      if pkgs.stdenv.isLinux
      then let
        inherit (osConfig.${namespace}.de) pantheon;
      in
        if pantheon.enable
        then module
        else {}
      else {};
  };
}
