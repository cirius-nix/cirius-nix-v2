{
  config,
  lib,
  namespace,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.development.api-client) apidog;

  pname = "apidog";
  version = "latest";
  pkg = pkgs.stdenv.mkDerivation {
    name = "${pname}-${version}";
    src = pkgs.fetchurl {
      url = "https://file-assets.apidog.com/download/Apidog-linux-manual-latest.tar.gz";
      sha256 = "sha256-7N+9moXwCPl4jufZgy0CjJ3aAETfmYgisv0OfOu0nqw=";
    };
    nativeBuildInputs = [
      pkgs.makeWrapper
    ];
    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./* $out/
      chmod +x $out/apidog

      mkdir -p $out/bin
      makeWrapper $out/apidog $out/bin/apidog \
        --prefix LD_LIBRARY_PATH "$NIX_LD_LIBRARY_PATH"

      runHook postInstall
    '';
    meta = with pkgs.lib; {
      description = "Apidog: All-in-one API design, documentation, debugging, and testing tool";
      homepage = "https://apidog.com/";
      license = licenses.unfree;
      platforms = ["x86_64-linux"];
    };
  };
in {
  options.${namespace}.development.api-client.apidog = {
    enable = mkEnableOption "Enable Apidog API Client installation";
  };
  config = mkIf apidog.enable {
    home.packages = [pkg];
    xdg.desktopEntries.apidog = {
      name = "Apidog";
      exec = "${pkg}/bin/apidog %u";
      type = "Application";
      mimeType = ["x-scheme-handler/apidog"];
      categories = ["Development"];
      noDisplay = false;
    };
  };
}
