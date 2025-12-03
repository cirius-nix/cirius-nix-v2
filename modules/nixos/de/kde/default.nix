{
  config,
  namespace,
  lib,
  pkgs,
  inputs,
  ...
}: {
  options.${namespace}.de.kde = {
    enable = lib.mkEnableOption "Enable KDE Plasma Desktop Environment";
  };
  config = lib.mkIf config.${namespace}.de.kde.enable {
    ${namespace}.base.sddm.enable = lib.mkForce true;
    environment.systemPackages = with pkgs; [
      kdePackages.plasma-browser-integration
      kdePackages.qtstyleplugin-kvantum
      kdePackages.kde-cli-tools
      kdePackages.kdeconnect-kde
      kitty
      alacritty
      inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
      (pkgs.stdenv.mkDerivation {
        pname = "plasma6-window-title-applet";
        version = "0.9.0";

        src = pkgs.fetchurl {
          url = "https://github.com/dhruv8sh/plasma6-window-title-applet/archive/refs/tags/v0.9.0.tar.gz";
          sha256 = "sha256-gqCunRDEfjbFEKRfuPeTiR3vga3foysGl7WAqE0YpsI=";
        };

        dontBuild = true;

        installPhase = ''
          mkdir -p $out/share/plasma/plasmoids/org.kde.windowtitle
          tar -xzf $src --strip-components=1 -C $out/share/plasma/plasmoids/org.kde.windowtitle
        '';
      })
    ];
    environment.variables.XCURSOR_SIZE = "24";
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.settings.General.DisplayServer = "wayland";
    # required for kde connect.
    networking.firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    # Qt/KDE applications segfault on start
    # find ${XDG_CACHE_HOME:-$HOME/.cache}/**/qmlcache -type f -delete
  };
}
