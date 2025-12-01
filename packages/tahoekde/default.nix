{
  lib,
  stdenv,
  fetchFromGitHub,
  variant ? "dark",
}: let
  # Map variant to color suffix used in the script
  colorVariant =
    if variant == "light"
    then "-Light"
    else "-Dark";
  elseColor =
    if variant == "light"
    then "Light"
    else "Dark";
  themeName = "MacTahoe";
  scaleVariants = ["" "-1.25x" "-1.5x"];
in
  stdenv.mkDerivation {
    pname = "mactahoe-kde";
    version = "unstable-2025-10-30";

    src = fetchFromGitHub {
      owner = "vinceliuice";
      repo = "MacTahoe-kde";
      rev = "master";
      sha256 = "sha256-dlIAQEgVS2M7eDFeKnt6/A2T59TmiZmDSRkog9BLBmI=";
    };

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall

      # Create destination directories
      mkdir -p $out/share/color-schemes
      mkdir -p $out/share/plasma/desktoptheme
      mkdir -p $out/share/plasma/layout-templates
      mkdir -p $out/share/plasma/look-and-feel
      mkdir -p $out/share/Kvantum
      mkdir -p $out/share/wallpapers
      mkdir -p $out/share/aurorae/themes

      # Install Kvantum theme
      cp -r Kvantum/${themeName} $out/share/Kvantum/

      # Install color scheme
      cp -r color-schemes/${themeName}${elseColor}.colors $out/share/color-schemes/

      # Install plasma desktop theme
      cp -r plasma/desktoptheme/${themeName}${colorVariant} $out/share/plasma/desktoptheme/
      cp -r plasma/desktoptheme/icons $out/share/plasma/desktoptheme/${themeName}${colorVariant}/

      # Install layout templates
      cp -r plasma/layout-templates/org.github.desktop.MacOS* $out/share/plasma/layout-templates/

      # Install look-and-feel
      cp -r plasma/look-and-feel/com.github.vinceliuice.${themeName}${colorVariant} $out/share/plasma/look-and-feel/

      # Install wallpapers
      cp -r wallpapers/${themeName} $out/share/wallpapers/
      cp -r wallpapers/${themeName}${colorVariant} $out/share/wallpapers/

      # Install Aurorae themes for each scale variant
      ${lib.concatMapStringsSep "\n" (scale: ''
          AURORA_DIR="$out/share/aurorae/themes/${themeName}${colorVariant}${scale}"
          mkdir -p "$AURORA_DIR"

          cp -r aurorae/${themeName}${colorVariant}${scale}/*.svg "$AURORA_DIR/"
          cp -r aurorae/${elseColor}rc "$AURORA_DIR/${themeName}${colorVariant}${scale}rc"
          cp -r aurorae/icons${colorVariant}/*.svg "$AURORA_DIR/"
          cp -r aurorae/metadata.desktop "$AURORA_DIR/"
          cp -r aurorae/metadata.json "$AURORA_DIR/"

          # Update metadata files with theme name
          substituteInPlace "$AURORA_DIR/metadata.desktop" \
            --replace "theme_name" "${themeName}${colorVariant}${scale}"
          substituteInPlace "$AURORA_DIR/metadata.json" \
            --replace "theme_name" "${themeName}${colorVariant}${scale}"
        '')
        scaleVariants}

      runHook postInstall
    '';

    passthru = {
      theme = "${themeName}${colorVariant}";
      auroraeTheme = "__aurorae__svg__${themeName}${colorVariant}";
      kvantumTheme =
        if variant == "light"
        then themeName
        else "${themeName}Dark";
      colorScheme = "${themeName}${elseColor}";
    };

    meta = with lib; {
      description = "MacTahoe KDE ${variant} theme - macOS-inspired theme for KDE Plasma";
      homepage = "https://github.com/vinceliuice/MacTahoe-kde";
      license = licenses.gpl3Plus;
      platforms = platforms.linux;
      maintainers = [];
    };
  }
