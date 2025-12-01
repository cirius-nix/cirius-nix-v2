{
  lib,
  stdenv,
  fetchFromGitHub,
  variant ? "dark",
}:
stdenv.mkDerivation rec {
  pname = "layan-kde";
  version = "2025-02-13";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Layan-kde";
    rev = version;
    sha256 = "sha256-ZK9m9Xf1XZE7k7suotr6dD2LciRoecAwphKhlqN9+sw=";
  };

  dontBuild = true;

  installPhase = ''
    themeName="Layan"
    colorSuffix=""
    elseColor=""

    if [ "$variant" = "light" ]; then
      colorSuffix="-light"
      elseColor="Light"
    fi

    auroraeDir=$out/share/aurorae/themes
    schemesDir=$out/share/color-schemes
    plasmaDir=$out/share/plasma/desktoptheme
    lookfeelDir=$out/share/plasma/look-and-feel
    kvantumDir=$out/share/Kvantum
    wallpaperDir=$out/share/wallpapers

    mkdir -p "$auroraeDir" "$schemesDir" "$plasmaDir" "$lookfeelDir" "$kvantumDir" "$wallpaperDir"

    # Aurorae
    cp -r aurorae/themes/$themeName* "$auroraeDir"

    # Color schemes
    cp -r color-schemes/$themeName$elseColor.colors "$schemesDir"

    # Kvantum
    cp -r Kvantum/$themeName* "$kvantumDir"

    # Plasma desktop themes
    mkdir -p "$plasmaDir/$themeName$colorSuffix"
    cp -r plasma/desktoptheme/common/* "$plasmaDir/$themeName$colorSuffix/"
    cp -r plasma/desktoptheme/$themeName$colorSuffix/* "$plasmaDir/$themeName$colorSuffix/"
    cp -r color-schemes/$themeName$elseColor.colors "$plasmaDir/$themeName$colorSuffix/colors"

    # Look and feel
    cp -r plasma/look-and-feel/com.github.vinceliuice.$themeName$colorSuffix "$lookfeelDir"

    # Wallpapers
    cp -r wallpaper/$themeName$colorSuffix "$wallpaperDir"
  '';

  passthru = {
    theme = "Layan";
    auroraeTheme =
      if variant == "light"
      then "__aurorae__svg__Layan-light"
      else "__aurorae__svg__Layan";
    kvantumTheme =
      if variant == "light"
      then "Layan"
      else "LayanDark";
    colorScheme = "Layan";
  };

  meta = with lib; {
    description = "Layan KDE ${variant} theme by vinceliuice";
    homepage = "https://github.com/vinceliuice/Layan-kde";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
