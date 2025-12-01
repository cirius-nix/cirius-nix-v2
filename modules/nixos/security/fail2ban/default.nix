{
  config,
  namespace,
  lib,
  pkgs,
  options,
  ...
}: {
  options.${namespace}.security.fail2ban = {
    enable = lib.mkEnableOption "Enable fail2ban service";
    jails = options.services.fail2ban.jails;
  };
  config = lib.mkIf config.${namespace}.security.fail2ban.enable {
    services.fail2ban = {
      enable = true;
      jails = {};
      extraPackages = with pkgs; [ipset];
    };
    services.openssh.settings = {
      LogLevel = lib.mkForce "VERBOSE";
    };
  };
}
