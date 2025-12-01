{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.development.editors.code = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Visual Studio Code editor.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.vscode;
      description = "Package to use for Visual Studio Code editor.";
    };
  };
  config = lib.mkIf config.${namespace}.development.editors.code.enable {
    programs.vscode = {
      enable = true;
      package = config.${namespace}.development.editors.code.package;
    };
  };
}
