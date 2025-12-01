{
  pkgs,
  namespace,
  lib,
  ...
} @ params: {
  config = let
    deEnabled = lib.${namespace}.de.checkEnabled params;
  in {
    environment.systemPackages = with pkgs;
      [
        # Base utilities
        neovim
        git
        gh
        fish
        wget
        unrar-wrapper
        # media codecs
        vulkan-loader
        vulkan-tools
        mesa
        nnn
        inotify-tools
        bandwhich
        smartmontools
        nix-tree
      ]
      ++ (lib.optionals deEnabled [
        vlc
        mpv-unwrapped
        kdePackages.gwenview
        nautilus
        kdePackages.dolphin
        d-spy
        iotas
        wl-clipboard
        gparted
        requestly
        gsmartcontrol
      ]);
  };
}
