{
  config,
  namespace,
  lib,
  pkgs,
  osConfig ? {},
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) intlib strlib;
in {
  options.${namespace}.browser.zen-browser = {
    enable = mkEnableOption "Enable zen browser";
    containers = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            id = intlib.mkOption 0 "Id of container";
            name = strlib.mkOption "" "Name of container";
            icon = strlib.mkOption "fingerprint" "Icon of container";
            color = strlib.mkOption "purple" "Color of container";
            spaceID = strlib.mkOption "" "UUID v4";
            spaceIcon = strlib.mkOption "" "Space icon";
            spacePosition = intlib.mkOption 0 "position of space";
          };
        });
      default = [];
      description = "Setup container for zen browser";
    };
  };
  config = let
    cfg = config.${namespace}.browser.zen-browser;
    enpassCfg = osConfig.${namespace}.security.enpass;
    mapContainer = opts: {
      "${opts.name}" = {
        inherit (opts) id color icon;
      };
    };
    mapContainerToSpace = opts: {
      "${opts.name}" = {
        id = opts.spaceID;
        position = opts.spacePosition;
        container = opts.id;
        icon = opts.spaceIcon;
      };
    };
  in
    mkIf cfg.enable {
      xdg.mimeApps = let
        value = let
          zen-browser = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight; # or twilight
        in
          zen-browser.meta.desktopFileName;
        associations = builtins.listToAttrs (map (name: {
            inherit name value;
          }) [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]);
      in {
        associations.added = associations;
        defaultApplications = associations;
      };

      wayland.windowManager.hyprland = mkIf (pkgs.stdenv.isLinux && config.wayland.windowManager.hyprland.enable) {
        settings = {
          windowrule = [
            "float,title:^$,class:^(zen-twilight)$"
            "move 100%-w-20 100,title:^$,class:^(zen-twilight)$"
            "float,title:^(Sign in – Google accounts — Zen Twilight)$,class:^(zen-twilight)$"
            "float,title:^(Picture-in-Picture)$,class:^(zen-twilight)$"
            "size 400 300,title:^(Picture-in-Picture)$,class:^(zen-twilight)$"
            "persistentsize,title:^(Picture-in-Picture)$,class:^(zen-twilight)$"
            "pin,title:^(Picture-in-Picture)$,class:^(zen-twilight)$"
            "move 100%-w-20 100%-w-20,title:^(Picture-in-Picture)$,class:^(zen-twilight)$"
          ];
        };
      };
      programs.zen-browser = {
        enable = true;
        nativeMessagingHosts = [pkgs.firefoxpwa];
        profiles."default" = {
          id = 0;
          isDefault = true;
          containersForce = true;
          containers = lib.foldl' lib.recursiveUpdate {
            Personal = {
              id = 1;
              color = "purple";
              icon = "fingerprint";
            };
          } (builtins.map mapContainer cfg.containers);
          spacesForce = true;
          spaces = lib.foldl' lib.recursiveUpdate {
            Personal = {
              id = "22040fb8-2c5a-4dbd-894a-986cb2004b3e";
              position = 1000;
              container = 1;
            };
          } (builtins.map mapContainerToSpace cfg.containers);
          settings = {
            "zen.widget.linux.transparency" = true;
            "zen.theme.gradient.show-custom-colors" = true;
            "zen.view.grey-out-inactive-windows" = false;
          };
        };
        #  zen.widget.linux.transparency = true
        # zen.theme.gradient.show-custom-colors = true
        # zen.view.grey-out-inactive-windows = false
        # https://mozilla.github.io/policy-templates/
        policies = {
          AutofillAddressEnabled = true;
          AutofillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisableFeedbackCommands = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableTelemetry = true;
          BlockAboutConfig = false;
          DontCheckDefaultBrowser = true;
          NoDefaultBookmarks = true;
          OfferToSaveLogins = false;
          EnableTrackingProtection = {
            Value = true;
            Locked = true;
            Cryptomining = true;
            Fingerprinting = true;
          };
          ExtensionSettings = let
            mkExtensionSettings = builtins.mapAttrs (
              _: pluginId: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
                installation_mode = "force_installed";
              }
            );
          in
            mkExtensionSettings (
              lib.foldl' lib.recursiveUpdate {} [
                {
                  "addon@darkreader.org" = "darkreader";
                }
                (lib.optionalAttrs enpassCfg.enable {
                  "firefox-enpass@enpass.io" = "enpass_password_manager";
                  "{5efceaa7-f3a2-4e59-a54b-85319448e305}" = "immersive_translate";
                })
              ]
            );
        };
      };
    };
}
