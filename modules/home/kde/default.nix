{
  pkgs,
  namespace,
  lib,
  config,
  ...
} @ params:
lib.${namespace}.kde.applyAttrOnEnabled params
{
  options.${namespace}.kde = {
    themeProfile = lib.mkOption {
      type = lib.types.enum ["tahoe"];
      default = "tahoe";
      description = "KDE theme profile to use.";
    };
  };
  config = let
    themeProfile = config.${namespace}.kde.themeProfile;
  in {
    ${namespace}.kde.profile.${themeProfile}.enable = lib.mkForce true;
    xdg.mimeApps = let
      associations = {
        "audio/aac" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/mp4" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/mpeg" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/mpegurl" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/ogg" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/vnd.rn-realaudio" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/vorbis" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-flac" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-mp3" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-mpegurl" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-ms-wma" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-musepack" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-oggflac" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-pn-realaudio" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-scpls" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-speex" = "org.kde.elisa.desktop";
        "audio/x-vorbis" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-vorbis+ogg" = "org.kde.elisa.desktop;mpv.desktop";
        "audio/x-wav" = "org.kde.elisa.desktop;mpv.desktop";
        "image/avif" = "org.kde.gwenview.desktop;okularApplication_kimgio.desktop";
        "image/bmp" = "org.kde.gwenview.desktop;okularApplication_kimgio.desktop";
        "image/heif" = "org.kde.gwenview.desktop;okularApplication_kimgio.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop;okularApplication_kimgio.desktop";
        "image/png" = "org.kde.gwenview.desktop;okularApplication_kimgio.desktop";
        "image/webp" = "org.kde.gwenview.desktop;okularApplication_kimgio.desktop";
        "image/x-icns" = "org.kde.gwenview.desktop";
        "inode/directory" = "org.kde.dolphin.desktop";
      };
    in {
      defaultApplications =
        {
          "inode/directory" = lib.mkForce "org.kde.dolphin.desktop";
        }
        // associations;
    };
    # qt = {
    #   platformTheme = "qtct";
    #   style.package = with pkgs; [darkly-qt6 darkly];
    # };
    programs.plasma = {
      enable = true;
      overrideConfig = true;
      immutableByDefault = true;
      windows.allowWindowsToRememberPositions = true;
      workspace = {
        clickItemTo = "open";
      };
      kwin = {};
      kscreenlocker = {
        autoLock = true;
        lockOnResume = true;
        lockOnStartup = false;
        passwordRequired = true;
        passwordRequiredDelay = 3;
        timeout = 1800;
      };
      configFile = {
        "kdeglobals" = {
          "KDE" = {
            "widgetStyle" = "Breeze";
          };
        };
        "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
        "kwinrc" = {
          "Desktops"."Number" = {
            value = 8;
            immutable = true;
          };
        };
      };
    };
  };
}
