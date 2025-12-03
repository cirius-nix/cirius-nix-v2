{lib, ...}: {
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

    panel = {
      mkOption = {
        height ? 40,
        offset ? 8,
        minLength ? null,
        maxLength ? null,
      }: {
        # required
        height = lib.mkOption {
          type = lib.types.int;
          default = height;
          description = "Panel height/height in pixels.";
        };
        offset = lib.mkOption {
          type = lib.types.int;
          default = offset;
          description = "Panel offset from screen edge in pixels.";
        };
        # optionals
        minLength = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = minLength;
          description = "Minimum length of the bottom panel in pixels.";
        };
        maxLength = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = maxLength;
          description = "Maximum length of the bottom panel in pixels.";
        };
      };
    };
  };
}
