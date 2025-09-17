{
  namespace,
  pkgs,
  ...
}:
let
in
{
  options.${namespace}.user = {
  };
  config = {
    home.packages = with pkgs; [
      home-manager
    ];
    services.home-manager = {
      autoExpire = {
        enable = true;
        frequency = "daily";
        store = {
          cleanup = true;
        };
      };
    };
  };
}
