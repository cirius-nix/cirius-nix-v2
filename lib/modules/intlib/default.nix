{lib, ...}: let
  inherit (lib) mkOption types;
  inherit (types) nullOr;
in {
  intlib = {
    mkOption = default: description:
      mkOption {
        inherit default description;
        type = types.int;
      };
    mkOption' = description:
      mkOption {
        inherit description;
        default = null;
        type = nullOr types.int;
      };
  };
}
