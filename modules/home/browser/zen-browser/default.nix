{
  config,
  namespace,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (lib.${namespace}) mkIntOption mkStrOption;
  inherit (config.${namespace}.browser) zen-browser;
  inherit (osConfig.${namespace}.security) enpass;

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
{
  options.${namespace}.browser.zen-browser = {
    enable = mkEnableOption "Enable zen browser";
    containers = lib.mkOption {
      type =
        with lib.types;
        listOf (submodule {
          options = {
            id = mkIntOption 0 "Id of container";
            name = mkStrOption "" "Name of container";
            icon = mkStrOption "fingerprint" "Icon of container";
            color = mkStrOption "purple" "Color of container";
            spaceID = mkStrOption "" "UUID v4";
            spaceIcon = mkStrOption "" "Space icon";
            spacePosition = mkIntOption 0 "position of space";
          };
        });
      default = [ ];
      description = "Setup container for zen browser";
    };
  };
  config = mkIf zen-browser.enable {
    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
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
        } (builtins.map mapContainer zen-browser.containers);
        spacesForce = true;
        spaces = lib.foldl' lib.recursiveUpdate {
          Personal = {
            id = "22040fb8-2c5a-4dbd-894a-986cb2004b3e";
            position = 1000;
            container = 1;
          };
        } (builtins.map mapContainerToSpace zen-browser.containers);
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
        ExtensionSettings =
          let
            mkExtensionSettings = builtins.mapAttrs (
              _: pluginId: {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
                installation_mode = "force_installed";
              }
            );
          in
          mkExtensionSettings (
            lib.foldl' lib.recursiveUpdate { } [
              {
                "addon@darkreader.org" = "darkreader";
              }
              (lib.optionalAttrs enpass.enable {
                "firefox-enpass@enpass.io" = "enpass_password_manager";
              })
            ]
          );
      };
    };
  };
}
