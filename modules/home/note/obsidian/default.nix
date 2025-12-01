{
  pkgs,
  config,
  namespace,
  lib,
  ...
}: {
  options.${namespace}.note.obsidian = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Obsidian note-taking application.";
    };
  };
  config = lib.mkIf config.${namespace}.note.obsidian.enable {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
