{lib, ...}: {
  settingByOS = {pkgs, ...}: settings:
    if pkgs.stdenv.isLinux
    then settings.linux or {}
    else if pkgs.stdenv.isDarwin
    then settings.darwin or {}
    else {};

  de = {
    checkEnabled = {
      config,
      namespace,
      pkgs,
      ...
    }:
      pkgs.stdenv.isLinux
      && (builtins.any (de: (config.${namespace}.de.${de}.enable or false)) [
        "hyprland"
        "cosmic"
        "kde"
        "gnome"
      ]);
  };

  # Batch enable/disable modules
  enableAll = list: conf:
    lib.foldl' lib.recursiveUpdate (lib.listToAttrs (lib.map (name: {
        inherit name;
        value = {enable = true;};
      })
      list))
    [conf];

  disableAll = list: conf:
    lib.foldl' lib.recursiveUpdate (lib.listToAttrs (lib.map (name: {
        inherit name;
        value = {enable = false;};
      })
      list))
    [conf];

  mustEnableAll = list: conf:
    lib.foldl' lib.recursiveUpdate (lib.listToAttrs (lib.map (name: {
        inherit name;
        value = {enable = lib.mkForce true;};
      })
      list))
    [conf];

  mustDisableAll = list: conf:
    lib.foldl' lib.recursiveUpdate (lib.listToAttrs (lib.map (name: {
        inherit name;
        value = {enable = lib.mkForce false;};
      })
      list))
    [conf];

  # check if any key inside object has enable = true
  checkAnyEnabled = obj:
    builtins.any (key: (obj.${key}.enable or false)) (lib.attrNames obj);

  ifNull = nullable: default:
    if nullable == null
    then default
    else nullable;
}
