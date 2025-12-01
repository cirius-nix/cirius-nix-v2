{
  namespace,
  pkgs,
  ...
}: {
  options.${namespace}.music = {};
  config = {
    home.packages = [
      pkgs.spotify
    ];
  };
}
