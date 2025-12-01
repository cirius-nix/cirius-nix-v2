{...}: {
  kde = {
    onEnabled = {
      pkgs,
      osConfig ? {},
      namespace,
      ...
    }: module:
      if (pkgs.stdenv.isLinux && osConfig.${namespace}.de.kde.enable)
      then module
      else {};
  };
}
