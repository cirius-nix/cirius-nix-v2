{
  pkgs,
  config,
  namespace,
  ...
}: {
  options.${namespace}.base.network = {
    hostName = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "nixos";
      description = "Hostname of the system.";
    };
  };
  config = {
    environment.systemPackages = [
      pkgs.curl
      pkgs.wget
      pkgs.unixtools.net-tools
    ];
    services.cloudflare-warp = {
      enable = true;
    };
    networking = {
      inherit (config.${namespace}.base.network) hostName;
      networkmanager.enable = true;
    };
  };
}
