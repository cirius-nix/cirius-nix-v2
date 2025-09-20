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
  };
}
