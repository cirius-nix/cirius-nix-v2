{
  config,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.base.security.gnupg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable SSH service.";
    };
  };
  config = lib.mkIf config.${namespace}.base.security.gnupg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
