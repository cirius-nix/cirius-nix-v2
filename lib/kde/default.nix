{...}: {
  kde = {
    applyAttrOnEnabled = {
      pkgs,
      osConfig ? {},
      namespace,
      ...
    }: module:
      if pkgs.stdenv.isLinux
      then let
        inherit (osConfig.${namespace}.de) kde;
      in
        if kde.enable
        then module
        else {}
      else {};
  };
}
