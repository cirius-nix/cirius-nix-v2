{lib, ...}: let
  inherit (lib) nullOr mkOption;
  inherit (lib.types) enum;
in {
  enumlib = {
    # Make ENUM options.
    mkOption' = values: default: description:
      mkOption {
        inherit default description;
        type = nullOr (enum values);
      };
    mkOption = values: default: description:
      mkOption {
        inherit default description;
        type = enum values;
      };
  };
}
