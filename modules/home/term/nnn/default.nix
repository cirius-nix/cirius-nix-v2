{
  config,
  namespace,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.${namespace}.term.nnn = {
    enable = mkEnableOption "Enable nnn file manager";
    bookmarks = mkOption {
      type = types.attrsOf types.str;
      default = {};
      description = "Bookmarks for nnn file manager";
    };
  };
  config = let
    cfg = config.${namespace}.term.nnn;
    inherit (lib) mkIf;
  in
    mkIf cfg.enable {
      programs.nnn = {
        enable = true;
        bookmarks = cfg.bookmarks;
      };
    };
}
