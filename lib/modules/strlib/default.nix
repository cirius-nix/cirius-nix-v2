{lib, ...}: {
  strlib = {
    mkOption = default: description:
      lib.mkOption {
        inherit default description;
        type = lib.types.str;
      };
    mkOption' = default: description:
      lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        inherit default description;
      };
  };
}
