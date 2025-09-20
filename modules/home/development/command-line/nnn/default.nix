{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (config.${namespace}.development.command-line) nnn;
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
in
{
  options.${namespace}.development.command-line.nnn = {
    enable = mkEnableOption "Enable nnn file manager";
    bookmarks = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Bookmarks for nnn file manager";
    };
  };
  config = mkIf nnn.enable {
    programs.nnn = {
      enable = true;
      bookmarks = nnn.bookmarks;
    };
  };
}
