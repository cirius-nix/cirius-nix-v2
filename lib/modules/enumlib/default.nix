{lib, ...}: let
  inherit (lib) nullOr enum mkOption;
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
