{
  lib,
  stdenv,
  fetchFromBitbucket,
}:
stdenv.mkDerivation rec {
  pname = "yet-another-monochrome-icon-set";
  version = "main";

  src = fetchFromBitbucket {
    owner = "dirn-typo";
    repo = "yet-another-monochrome-icon-set";
    rev = "main";
    sha256 = "sha256-KpFglAEemVZPMG9cPc64MXhsfRjrNxaYsAwJ/Jx6fq8=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r . $out/share/icons/${pname}
  '';

  passthru = {
    theme = "yet-another-monochrome-icon-set";
  };

  meta = with lib; {
    description = "Yet Another Monochrome Icon Set";
    homepage = "https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set";
    license = licenses.gpl3Plus;
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
