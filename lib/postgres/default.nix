{
  lib,
  namespace,
  ...
}:
let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) listOf submodule;
  inherit (lib.${namespace}) mkStrOption;

  initUserType = submodule {
    options = {
      enable = mkEnableOption "Enable this user";
      username = mkStrOption "" "The database username.";
      password = mkStrOption "" "The database user password.";
    };
  };

  mkUserOption =
    default: description:
    mkOption {
      type = submodule initUserType;
      inherit default description;
    };

  initDBType = submodule {
    options = {
      db = {
        name = mkStrOption "" "The database name.";
        schema = mkStrOption "" "The database schema.";
      };
      admin = mkUserOption { } "admin user";
      writer = mkUserOption { } "writer user";
      reader = mkUserOption { } "reader user";
    };
  };

  mkInitDBOption =
    default: description:
    mkOption {
      type = initDBType;
      inherit default description;
    };

  mkInitDBsOption =
    default: description:
    mkOption {
      type = listOf initDBType;
      inherit default description;
    };
in
{
  postgres = {
    types = {
      inherit initUserType initDBType;
    };
    options = {
      inherit mkUserOption mkInitDBOption mkInitDBsOption;
    };
  };
}
