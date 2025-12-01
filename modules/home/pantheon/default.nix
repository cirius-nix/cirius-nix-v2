{
  namespace,
  lib,
  config,
  ...
} @ params:
lib.${namespace}.pantheon.onEnabled params
{
  options.${namespace}.pantheon = {
  };
  config = {
    xdg.mimeApps = {
      defaultApplications = {
        "x-scheme-handler/settings" = "io.elementary.settings.desktop";
      };
    };
  };
}
