{pkgs, ...}: {
  config = {
    programs = {
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          # add any missing dynamic libraries for unpackaged programs
          # here, NOT in environment.systemPackages.
          glib
          glibc
          gtk3
          nss
          nspr
          cups
          xorg.libX11
          xorg.libxcb
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          mesa
          pango
          cairo
          alsa-lib
          at-spi2-atk
          at-spi2-core
          dbus
          expat
          libdrm
          libgbm
          libgcc
          libxkbcommon
          libGL
        ];
      };
    };
  };
}
