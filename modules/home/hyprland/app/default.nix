{
  lib,
  config,
  namespace,
  ...
} @ inputs:
lib.${namespace}.hyprland.applyAttrOnEnabled inputs {
  options.${namespace}.hyprland.app = let
    inherit (lib.${namespace}) mkListOption mkStrOption mkEnumOption;
    appEntryType = lib.types.submodule {
      options = {
        id = mkStrOption "" "Identifier of the application.";
        command = mkStrOption "" "Command to launch the application.";
        icon = mkStrOption "" "Icon for the application.";
        wsName = mkStrOption "" "Workspace name to open the application in.";
        shortcut = mkListOption lib.types.str [] "Shortcut to launch the application.";
        floatedBy = mkEnumOption [null "class" "title"] null "Whether to open the application in floating mode.";
        titleName = mkStrOption "" "Title of the application window.";
        launchIn = mkEnumOption [null "browser" "private-browser" "term"] null "Launch the application in a specific launcher.";
        browserURL = mkStrOption "" "URL to open when launching in browser mode.";
        class = mkStrOption "" "Window class of the application.";
        forceTermClass = lib.mkEnableOption "Force setting the terminal class when launched in a terminal.";
        size = mkStrOption "" "Size of the application window (e.g., 800 600).";
        persistentSize = lib.mkEnableOption "Remember the size of the application window.";
        pinned = lib.mkEnableOption "Pin the application by default in the taskbar.";
        move = mkStrOption "" "Move the application window to a specific position (e.g., 100%-w-20).";
        forceFocus = lib.mkEnableOption "Force focus on the application when launched.";
        focusedBy = mkEnumOption ["class" "title"] "class" "Method to identify the application for focusing.";
        keygroupBinding = lib.mkOption {
          type = lib.types.nullOr (lib.types.submodule {
            options = {
              keygroup = mkStrOption "" "Name of the keygroup to bind this app to.";
              key = mkStrOption "" "Key within the keygroup to bind this app to.";
              resetAfter = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Whether to reset to the main keymap after launching this app.";
              };
            };
          });
          default = null;
          description = ''
            Bind this app to a specific keygroup instead of using a global shortcut.

            Example:
            keygroupBinding = {
              keygroup = "windowManagement";
              key = "F";
              resetAfter = true;
            };

            This will bind the app to the 'F' key within the 'windowManagement' keygroup,
            and will exit the keygroup after launching the app.
          '';
        };
      };
    };
    termLauncherType = lib.types.submodule {
      options = {
        command = mkStrOption "alacritty" "Terminal emulator to use.";
        classFlag = mkStrOption "--class" "Flag to set the window class in the terminal emulator.";
        args = mkListOption lib.types.str [] "Arguments to pass to the terminal emulator.";
      };
    };
    browserLauncherType = lib.types.submodule {
      options = {
        command = mkStrOption "zen" "Web browser to use.";
        newWindowFlag = mkStrOption "--new-window" "Flag to open a new window in the web browser.";
        newPrivateWindowFlag = mkStrOption "--private-window" "Flag to open a new private window in the web browser.";
        classFlag = mkStrOption "--class" "Flag to set the window class in the web browser.";
      };
    };
  in {
    termLauncher = lib.mkOption {
      type = termLauncherType;
      default = {
        command = "alacritty";
        classFlag = "--class";
        args = ["-e"];
      };
      description = "Terminal launcher configuration.";
    };
    browserLauncher = lib.mkOption {
      type = browserLauncherType;
      default = {
        command = "google-chrome-stable";
        newWindowFlag = "--new-window";
        newPrivateWindowFlag = "--incognito";
        classFlag = "--class";
      };
      description = "Web browser launcher configuration.";
    };
    list = mkListOption appEntryType [] "List of apps to config.";
    keygroupBindings = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          keygroupName = mkStrOption "" "Name of the keygroup.";
          bindings = mkListOption (lib.types.submodule {
            options = {
              key = mkStrOption "" "Key to bind within the keygroup.";
              command = mkStrOption "" "Command to execute.";
              type = mkEnumOption ["bind" "binde" "bindm"] "bind" "Type of binding.";
              resetAfter = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to reset to the main keymap after this binding.";
              };
            };
          }) [] "List of bindings for this keygroup.";
        };
      });
      default = [];
      description = "Generated keygroup bindings from apps.";
      internal = true;
    };
    system = {
      network = lib.mkOption {
        type = appEntryType;
        default = {
          id = "nmtui";
          launchIn = "term";
          floatedBy = "class";
          forceTermClass = true;
        };
        description = "Network manager application.";
      };
    };
  };
  config = let
    inherit (config.${namespace}.hyprland.app) list termLauncher browserLauncher system;
    inherit (lib.${namespace}.hyprland) mkShortcut getAppCmdByTerm;

    getAppClass = app:
      if app.class != ""
      then app.class
      else app.id;

    mustAppClass = app:
      if (getAppClass app) == ""
      then throw "App ${app.id} must have a class or id defined."
      else getAppClass app;

    # Generate window rule to move applications to specific positions
    movedApps = lib.filter (app: app.move != "" && app.floatedBy != null) list;
    groupedByAppPositions = builtins.groupBy (app: app.move) movedApps;
    appPositionRules =
      lib.mapAttrsToList
      (
        position: apps: let
          classes = builtins.map mustAppClass apps;
          classRegex = "^(${lib.concatStringsSep "|" classes})$";
        in "move ${position}, class:${classRegex}"
      )
      groupedByAppPositions;

    # Generate persistent size rules for applications
    persistentSizeApps = lib.filter (app: app.persistentSize == true && app.size != "" && app.floatedBy != null) list;
    persistentSizeClasses = builtins.map mustAppClass persistentSizeApps;
    persistentSizeRule = "persistentsize, class: ^(${lib.concatStringsSep "|" persistentSizeClasses})$";

    # Generate a comma-separated list of pinned classes
    pinnedWindows = lib.filter (app: app.pinned == true) list;
    pinnedClasses = builtins.map mustAppClass pinnedWindows;
    pinnedByClassesRule = "pin, class: ^(${builtins.concatStringsSep "|" pinnedClasses})$";

    # Generate window rules for applications forced focused by class
    focusedWindows = lib.filter (app: app.forceFocus == true) list;
    appForcedFocusRules = builtins.map (e:
      if e.focusedBy == "title"
      then "stayfocused, class: ^(${mustAppClass e})$, title:^(${e.titleName})$"
      else "stayfocused, class: ^(${mustAppClass e})$")
    focusedWindows;

    # Generate window rules for applications floated by class
    floatedWindows = lib.filter (app: app.floatedBy == "class") list;
    floatClasses = builtins.map mustAppClass (floatedWindows ++ [system.network]);
    floatedByClassRule = "float, class: ^(${lib.concatStringsSep "|" floatClasses})$";

    # Generate window rules for applications floated by title
    appsFloatByTitle = lib.filter (app: app.floatedBy == "title" && app.titleName != "") list;
    floatedByTitleRules =
      builtins.map (e: "float, class: ^(${mustAppClass e})$, title:^(${e.titleName})$")
      appsFloatByTitle;

    # Group applications by size & generate window rules for each group
    groupedByFloatSize =
      builtins.groupBy
      (app: app.size)
      (builtins.filter (app: app.size != "" && app.floatedBy != null) list);
    appSizeRules =
      lib.mapAttrsToList
      (
        size: apps: let
          classes = builtins.map mustAppClass apps;
          classRegex = "^(${lib.concatStringsSep "|" classes})$";
        in "size ${size}, class:${classRegex}"
      )
      groupedByFloatSize;

    # Generate commands for apps based on their launch type
    getAppCommand = app:
      if app.launchIn == "term"
      then getAppCmdByTerm app termLauncher
      else if app.launchIn == "browser"
      then "${browserLauncher.command} --class=${mustAppClass app} ${browserLauncher.newWindowFlag} ${app.browserURL}"
      else if app.launchIn == "private-browser"
      then "${browserLauncher.command} --class=${mustAppClass app} ${browserLauncher.newPrivateWindowFlag} ${app.browserURL}"
      else if app.command != ""
      then app.command
      else app.id;

    # Filter apps that have keygroup bindings
    appsWithKeygroupBindings = lib.filter (app: app.keygroupBinding != null) list;

    # Generate keygroup bindings for apps
    generateKeygroupBindings = apps: let
      groupedByKeygroup = builtins.groupBy (app: app.keygroupBinding.keygroup) apps;
    in
      lib.mapAttrsToList (keygroupName: keygroupApps: {
        inherit keygroupName;
        bindings =
          builtins.map (app: {
            key = app.keygroupBinding.key;
            command = "exec, ${getAppCommand app}";
            type = "bind";
            resetAfter = app.keygroupBinding.resetAfter;
          })
          keygroupApps;
      })
      groupedByKeygroup;

    keygroupAppBindings = generateKeygroupBindings appsWithKeygroupBindings;
  in {
    # Export keygroup bindings for use by the keygroup module
    ${namespace}.hyprland.app.keygroupBindings = keygroupAppBindings;

    wayland.windowManager.hyprland.settings = {
      windowrule =
        floatedByTitleRules
        ++ appSizeRules
        ++ appPositionRules
        ++ appForcedFocusRules
        ++ [floatedByClassRule pinnedByClassesRule persistentSizeRule];

      bind = let
        mapTerm = e: "${mkShortcut {
          inherit (e) shortcut;
          command = getAppCmdByTerm e termLauncher;
        }}";
        mapBrowser = e: "${mkShortcut {
          inherit (e) shortcut;
          command = "${browserLauncher.command} --class=${mustAppClass e} ${browserLauncher.newWindowFlag} ${e.browserURL}";
        }}";
        mapPrivateBrowser = e: "${mkShortcut {
          inherit (e) shortcut;
          command = "${browserLauncher.command} --class=${mustAppClass e} ${browserLauncher.newPrivateWindowFlag} ${e.browserURL}";
        }}";

        listTerm = lib.filter (e: e.launchIn == "term" && e ? shortcut && builtins.length e.shortcut >= 2 && e.keygroupBinding == null) list;
        listBrowser = lib.filter (e: e.launchIn == "browser" && e ? shortcut && e ? browserURL && builtins.length e.shortcut >= 2 && e.keygroupBinding == null) list;
        listPrivateBrowser = lib.filter (e: e.launchIn == "private-browser" && e ? shortcut && e ? browserURL && builtins.length e.shortcut >= 2 && e.keygroupBinding == null) list;
      in
        (map mapTerm listTerm) ++ (map mapBrowser listBrowser) ++ (map mapPrivateBrowser listPrivateBrowser);
    };
  };
}
