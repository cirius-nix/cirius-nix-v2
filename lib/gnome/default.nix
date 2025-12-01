{...}: {
  gnome = {
    applyAttrOnEnabled = {
      pkgs,
      osConfig ? {},
      namespace,
      ...
    }: module:
      if pkgs.stdenv.isLinux
      then let
        inherit (osConfig.${namespace}.de) gnome;
      in
        if gnome.enable
        then module
        else {}
      else {};
  };
}
