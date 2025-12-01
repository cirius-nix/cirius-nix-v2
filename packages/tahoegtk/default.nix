{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "mactahoe-gtk-theme";
  version = "unstable-2025-10-30";

  src = ./MacTahoe-Dark.tar.xz;

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/MacTahoe-Dark
    cp -a * $out/share/themes/MacTahoe-Dark/

    runHook postInstall
  '';

  passthru = {
    themeName = "MacTahoe-Dark";
  };

  meta = with lib; {
    description = "MacTahoe theme ported to GTK applications";
    homepage = "github.com/vinceliuice/MacTahoe-gtk-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [];
  };
}
