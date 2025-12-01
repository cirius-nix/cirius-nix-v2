{lib, ...}: let
  inherit (lib) mkOption types;
  inherit (types) nullOr enum;
in {
  mkEnumOption = values: default: description:
    mkOption {
      inherit default description;
      type = nullOr (enum values);
    };
  # flatDist flat multiple level of lists and remove duplicates
  flatDist = lists: lib.unique (lib.flatten lists);
  mkIntOption = default: description:
    mkOption {
      inherit default description;
      type = types.int;
    };
  mkIntOrNullOption = default: description:
    mkOption {
      inherit default description;
      type = nullOr types.int;
    };
  mkStrOption = default: description:
    mkOption {
      inherit default description;
      type = types.str;
    };
  mkListOption = type: default: description:
    mkOption {
      inherit default description;
      type = types.listOf type;
    };
  onLinux = {pkgs, ...}: module:
    if pkgs.stdenv.isLinux
    then module
    else {};
  strictMerge = let
    checkOverlap = a: b: let
      commonKeys = lib.intersectLists (lib.attrNames a) (lib.attrNames b);
    in
      if commonKeys != []
      then throw "strictMerge: overlapping keys: ${lib.concatStringsSep ", " commonKeys}"
      else a // b;
  in
    checkOverlap;

  linux = {
    withInputModule = {pkgs, ...}: module:
      if pkgs.stdenv.isLinux
      then module
      else {};
  };

  system = {
    checkGuiEnabled = {
      config,
      namespace,
      ...
    }:
      builtins.any (de: (config.${namespace}.de.${de}.enable or false)) [
        "hyprland"
        "cosmic"
        "kde"
        "gnome"
      ];
  };

  # loop all elems inside list and create object key with enable =  true.
  enableAll = list: conf:
    lib.foldl' lib.recursiveUpdate (lib.listToAttrs (lib.map (name: {
        inherit name;
        value = {enable = true;};
      })
      list))
    [conf];

  # check if any key inside object has enable = true
  checkAnyEnabled = obj:
    builtins.any (key: (obj.${key}.enable or false)) (lib.attrNames obj);
}
