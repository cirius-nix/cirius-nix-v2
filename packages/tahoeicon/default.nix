# https://github.com/vinceliuice/MacTahoe-icon-theme
{
  lib,
  stdenv,
  fetchFromGitHub,
  variant ? "dark", # default theme variant: dark | light | blue | purple | ...
}:
stdenv.mkDerivation {
  pname = "MacTahoe-icon-theme";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "MacTahoe-icon-theme";
    rev = "master";
    hash = "sha256-2Tj4PmecvVA3T5GmKBkYdkjnspIue/u0LiYPaNMXk10=";
  };

  dontBuild = true;

  installPhase = let
    themeName = "MacTahoe";
  in ''
    runHook preInstall

    # Create destination
    mkdir -p $out/share/icons

    DEST_DIR="$out/share/icons"
    SRC_DIR="$PWD"

    # Make theme directory
    mkdir -p "$DEST_DIR/${themeName}-${variant}"

    # Copy base files
    cp -r src/index.theme "$DEST_DIR/${themeName}-${variant}"
    cp -r {COPYING,AUTHORS} "$DEST_DIR/${themeName}-${variant}"

    # Fix name in index.theme
    sed -i "s/${themeName}/${themeName}-${variant}/g" "$DEST_DIR/${themeName}-${variant}/index.theme"

    # Copy icon assets (simplified dark/light selection)
    case "$variant" in
      dark)
        cp -r src/{actions,apps,categories,devices,emotes,emblems,mimes,places,preferences,status} \
          "$DEST_DIR/${themeName}-${variant}"

        # Change SVG colors for dark variant
        find "$DEST_DIR/${themeName}-${variant}" -type f -name "*.svg" -exec \
          sed -i 's/#363636/#dedede/g' {} +

        ;;
      light)
        cp -r src/{actions,apps,categories,devices,emotes,emblems,mimes,places,preferences,status} \
          "$DEST_DIR/${themeName}-${variant}"

        # Change SVG colors for light variant
        find "$DEST_DIR/${themeName}-${variant}" -type f -name "*.svg" -exec \
          sed -i 's/#f2f2f2/#363636/g' {} +

        ;;
      *)
        # Default variant
        cp -r src/{actions,animations,apps,categories,devices,emotes,emblems,mimes,places,preferences,status} \
          "$DEST_DIR/${themeName}-${variant}"
        ;;
    esac

    # Make @2x symlinks (same as original)
    (
      cd "$DEST_DIR/${themeName}-${variant}"
      for dir in actions animations apps categories devices emotes emblems mimes places preferences status; do
        ln -sf "$dir" "$dir@2x"
      done
    )

    # Install cursors (simplified)
    if [ -d "$SRC_DIR/cursors/dist/cursors" ]; then
      cp -r "$SRC_DIR/cursors/dist/cursors" "$DEST_DIR/${themeName}-${variant}/"
      cp -r "$SRC_DIR/cursors/src/scalable" "$DEST_DIR/${themeName}-${variant}/cursors_scalable"
    fi

    runHook postInstall
  '';

  passthru = {
    themeName = "MacTahoe-${variant}";
  };

  meta = with lib; {
    description = "MacTahoe Icon ${variant} by vinceliuice";
    homepage = "https://github.com/vinceliuice/MacTahoe-icon-theme";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
