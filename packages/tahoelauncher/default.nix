# https://github.com/vinceliuice/MacTahoe-icon-theme
{
  stdenv,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "Tahoe Launcher";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "EliverLara";
    repo = "TahoeLauncher";
    rev = "master";
    hash = "sha256-YhZ0nXT4E/ZBKa3/F0Nh79PJJTRse8zFsOWeJnLXmfE=";
  };

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/TahoeLauncher
    cp -r ./* $out/share/plasma/plasmoids/TahoeLauncher
  '';

  meta = with pkgs.lib; {
    description = "KDE Plasma 6 Tahoe Launcher widget";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [maintainers."Hieu Tran"];
  };
}
