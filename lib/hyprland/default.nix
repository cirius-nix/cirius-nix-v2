{...}: let
  getAppCmdByTerm = app: term: let
    appCmd =
      if app.command != ""
      then app.command
      else app.id;
    appClass =
      if app.class != ""
      then app.class
      else app.id;
  in
    if app.launchIn == "term"
    then let
      termClassFlag =
        if app.forceTermClass == true
        then term.classFlag
        else "";
      termArgs =
        if term.args == []
        then ""
        else builtins.concatStringsSep " " term.args;
    in "${term.command} ${termClassFlag} ${appClass} ${termArgs} ${appCmd}"
    else appCmd;

  # Get app by ID, throw if not found
  getAppById = id: appList: let
    matched = builtins.filter (app: app.id == id) appList;
  in
    if matched == []
    then throw "App ID '${id}' not found in appList"
    else builtins.head matched;
in {
  hyprland = {
    applyAttrOnEnabled = {
      pkgs,
      osConfig ? {},
      namespace,
      ...
    }: module:
      if pkgs.stdenv.isLinux
      then let
        inherit (osConfig.${namespace}.de) hyprland;
      in
        if hyprland.enable
        then module
        else {}
      else {};
    mkShortcut = {
      shortcut,
      command,
      ...
    }: let
      mod = builtins.elemAt shortcut 0;
      key = builtins.elemAt shortcut 1;
    in "${mod}, ${key}, exec, ${command}";
    mkTagShortcut = {
      shortcut,
      command,
      tag,
      ...
    }: let
      mod = builtins.elemAt shortcut 0;
      key = builtins.elemAt shortcut 1;
    in "${mod}, ${key}, exec, ${command}, tagwindow, ${tag}";
    getAppCmdById = id: term: appList: getAppCmdByTerm (getAppById id appList) term;
    inherit getAppCmdByTerm getAppById;
  };
}
