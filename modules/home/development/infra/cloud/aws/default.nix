{
  config,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.development.infra.cloud.aws = {
    configPlaceholders = lib.${namespace}.listlib.mkOption lib.types.str [] "SOPS placeholders to be replaced in AWS config files";
  };
  config = let
    cfg = config.${namespace}.development.infra.cloud.aws;
    user = config.snowfallorg.user;
    configPath = "${user.home.directory}/.aws/config";
  in {
    sops.templates = {
      "${namespace}/${user.name}:${configPath}" = {
        # owner can read/write, group and others have no permissions
        mode = "0600";
        path = configPath;
        content = lib.concatMapStringsSep "\n" (p: config.sops.placeholder."${p}") cfg.configPlaceholders;
      };
    };
  };
}
