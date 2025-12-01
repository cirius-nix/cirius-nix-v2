{lib, ...}: {
  listlib = {
    mkOption = type: default: description:
      lib.mkOption {
        inherit default description;
        type = lib.types.listOf type;
      };
    mkOption' = default: description:
      lib.mkOption {
        inherit default description;
        type = lib.types.nullOr (lib.types.listOf lib.types.any);
      };
    # flatDist: Flatten a list of lists and remove duplicates.
    flatDist = lists: lib.unique (lib.flatten lists);
  };
}
