params: let
  inherit (params) lib namespace osConfig pkgs;
in
  lib.${namespace}.settingByOS params {
    linux.config = let
      inherit (lib) mkIf;
      inherit (osConfig.${namespace}.security) enpass;
    in
      mkIf enpass.enable {
        home.packages = with pkgs; [
          enpass-cli
        ];
      };
  }
