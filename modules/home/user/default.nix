{
  namespace,
  pkgs,
  ...
}:
{
  options.${namespace}.user = {
  };
  config = {
    home.packages = with pkgs; [
      home-manager
    ];
  };
}
