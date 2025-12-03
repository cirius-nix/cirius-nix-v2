{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation {
  pname = "leaf-kde";
  version = "main";

  src = fetchFromGitHub {
    owner = "hieutran21198";
    repo = "leaf-kde";
    rev = "main";
    sha256 = "sha256-5KY9JmIfwqWd/i2EW4su4v/f7PO/dFyu097Pxn6liWA=";
  };

  dontBuild = true;

  buildInputs = [];
  installPhase = ''
    mkdir -p $out/share

    # Look and feel
    if [ -d look-and-feel ]; then
      mkdir -p $out/share/plasma/look-and-feel
      cp -r look-and-feel/* $out/share/plasma/look-and-feel/
    fi

    # Desktop theme
    if [ -d desktoptheme ]; then
      mkdir -p $out/share/plasma/desktoptheme
      cp -r desktoptheme/* $out/share/plasma/desktoptheme/
    fi

    # Aurorae
    if [ -d aurorae ]; then
      mkdir -p $out/share/aurorae/themes
      cp -r aurorae/* $out/share/aurorae/themes/
    fi

    # Color schemes
    if [ -d color-schemes ]; then
      mkdir -p $out/share/color-schemes
      cp -r color-schemes/* $out/share/color-schemes/
    fi

    # Wallpapers
    if [ -d wallpapers ]; then
      mkdir -p $out/share/wallpapers
      cp -r wallpapers/* $out/share/wallpapers/
    fi

    # Konsole
    if [ -d konsole ]; then
      mkdir -p $out/share/konsole
      cp -r konsole/* $out/share/konsole/
    fi

    # Kate color schemes
    if [ -d kate ]; then
      mkdir -p $out/share/org.kde.syntax-highlighting/themes
      cp -r kate/* $out/share/org.kde.syntax-highlighting/themes/
    fi
  '';

  passthru = {
    # global style
    theme = "Leaf";
    # aurorae
    decoration = {
      lib = "org.kde.kwin.aurorae";
      dark = "__aurorae__svg__leaf-dark";
      light = "__aurorae__svg__leaf-light";
    };
    # colors
    colorScheme = {
      light = "LeafLight";
      dark = "LeafDark";
    };
    # plasma style
    lookAndFeel = {
      light = "leaf-light";
      dark = "leaf-dark";
    };
    # wallpaper
    wallpaper = {
      dark = "share/wallpapers/leaf-dark/contents/images/1920x1080.png";
      light = "share/wallpapers/leaf-light/contents/images/1920x1080.png";
    };
    # splash screen
    splashScreen = {
      engine = "KSplashQML";
      theme = "leaf-dark";
    };
  };

  meta = with lib; {
    description = "KDE theme pack (look-and-feel, desktop theme, aurorae, color schemes, wallpapers, konsole and kate color schemes)";
    homepage = "https://github.com/hieutran21198/leaf-kde";
    license = licenses.mit;
    maintainers = [
      {
        name = "Minh Hieu Tran";
        email = "hieu.tran21198@gmail.com";
        github = "hieutran21198";
      }
    ];
    platforms = platforms.linux;
  };
}
