{ lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (types) nullOr enum;
in
{
  mkEnumOption =
    values: default: description:
    mkOption {
      inherit default description;
      type = nullOr (enum values);
    };
  # flatDist flat multiple level of lists and remove duplicates
  flatDist = lists: lib.unique (lib.flatten lists);
  mkIntOption =
    default: description:
    mkOption {
      inherit default description;
      type = types.int;
    };
  mkStrOption =
    default: description:
    mkOption {
      inherit default description;
      type = types.str;
    };
  mkListOption =
    type: default: description:
    mkOption {
      inherit default description;
      type = types.listOf type;
    };
}
