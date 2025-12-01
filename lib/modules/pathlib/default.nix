{lib, ...}: {
  pathlib = {
    mkOption = default: description:
      lib.mkOption {
        inherit default description;
        type = lib.types.path;
      };
    mkOption' = default: description:
      lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        inherit default description;
      };
  };
}
