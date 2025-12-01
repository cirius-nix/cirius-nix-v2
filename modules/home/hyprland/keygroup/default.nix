{
  lib,
  config,
  namespace,
  ...
} @ inputs:
lib.${namespace}.hyprland.applyAttrOnEnabled inputs {
  options.${namespace}.hyprland.keygroup = let
    inherit (lib.${namespace}) mkListOption mkStrOption mkEnumOption;
    keygroupEntryType = lib.types.submodule {
      options = {
        id = mkStrOption "" "Identifier of the keygroup (used as submap name).";
        shortcut = mkListOption lib.types.str [] "Shortcut to trigger the keygroup (e.g., ['$mod' 'W']).";
        bindings = mkListOption (lib.types.submodule {
          options = {
            key = mkStrOption "" "Key to bind within the keygroup.";
            command = mkStrOption "" "Command to execute.";
            type = mkEnumOption ["bind" "binde" "bindm"] "bind" "Type of binding (bind, binde, bindm).";
            resetAfter = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to reset to the main keymap after this binding.";
            };
          };
        }) [] "List of key bindings within this keygroup.";
        children = mkListOption keygroupEntryType [] "List of child keygroups.";
      };
    };
  in
    mkListOption keygroupEntryType [] "List of keygroups to configure in Hyprland.";

  config = let
    inherit (config.${namespace}.hyprland) keygroup;
    
    # Get app keygroup bindings if they exist
    appKeygroupBindings = config.${namespace}.hyprland.app.keygroupBindings or [];
    
    # Function to merge app bindings into existing keygroups
    mergeAppBindings = group: let
      # Find app bindings for this keygroup
      appBindingsForGroup = lib.filter (appBinding: appBinding.keygroupName == group.id) appKeygroupBindings;
      # Extract the bindings lists and concatenate them
      appBindings = lib.concatMap (appBinding: appBinding.bindings) appBindingsForGroup;
    in group // {
      bindings = group.bindings ++ appBindings;
    };
    
    # Apply app bindings to all keygroups
    mergedKeygroups = builtins.map mergeAppBindings keygroup;

    # Separate default keygroup from regular keygroups
    defaultKeygroups = lib.filter (group: group.id == "default") mergedKeygroups;
    regularKeygroups = lib.filter (group: group.id != "default") mergedKeygroups;

    # Generate global bindings from default keygroup
    generateDefaultBindings = defaultGroups: let
      defaultGroup = if builtins.length defaultGroups > 0 then builtins.head defaultGroups else null;
    in if defaultGroup == null then [] else
      builtins.map (binding: 
        "${binding.type} = ${builtins.elemAt defaultGroup.shortcut 0}, ${binding.key}, ${binding.command}"
      ) defaultGroup.bindings;

    # Generate a main submap and its children
    generateSubmap = group: let
      # Entry binding for top-level groups
      entryBinding = [
        "bind = ${builtins.elemAt group.shortcut 0}, ${builtins.elemAt group.shortcut 1}, submap, ${group.id}"
      ];

      # Submap declaration
      submapDecl = "submap = ${group.id}";

      # Generate individual bindings with resetAfter handling
      generateBinding = binding: let
        baseBinding = "${binding.type} = , ${binding.key}, ${binding.command}";
      in
        if binding.resetAfter
        then [
          baseBinding
          "${binding.type} = , ${binding.key}, submap, reset"
        ]
        else [
          baseBinding
        ];

      # Group's own bindings (flattened)
      groupBindings = lib.concatMap generateBinding group.bindings;

      # Child submap bindings
      childBindings =
        builtins.map (
          child: "bind = , ${builtins.elemAt child.shortcut 1}, submap, ${child.id}"
        )
        group.children;

      # Escape bindings
      escapeBindings = [
        "bind = , escape, submap, reset"
        "bind = , enter, submap, reset"
      ];

      # Tab binding for cycling (if this is windowManagement)
      tabBinding =
        if group.id == "windowManagement"
        then [
          "binde = , tab, cyclenext"
        ]
        else [];

      # Submap close
      submapClose = "submap = reset # end of submap";

      # Main submap lines
      mainSubmapLines = entryBinding ++ [submapDecl] ++ groupBindings ++ childBindings ++ escapeBindings ++ tabBinding ++ [submapClose];

      # Generate child submaps
      childSubmaps = lib.concatMap (generateChildSubmap group.id) group.children;
    in
      mainSubmapLines ++ childSubmaps;

    # Generate child submaps with proper indentation and comments
    generateChildSubmap = parentId: child: let
      # Comment header
      commentHeader = "  # child of ${parentId} submap";

      # Submap declaration
      submapDecl = "  submap = ${child.id}";

      # Generate individual bindings with resetAfter handling
      generateChildBinding = binding: let
        baseBinding = "  ${binding.type} = , ${binding.key}, ${binding.command}";
      in
        if binding.resetAfter
        then [
          baseBinding
          "  ${binding.type} = , ${binding.key}, submap, reset"
        ]
        else [
          baseBinding
        ];

      # Child's own bindings (flattened)
      childBindings = lib.concatMap generateChildBinding child.bindings;

      # Escape bindings - route to 'reset' submap
      escapeBindings = [
        "  bind = , escape, submap, reset # route to 'reset' submap"
        "  bind = , enter, submap, reset  # route to 'reset' submap"
      ];

      # Submap close
      submapClose = "  submap = reset # end of submap";
    in
      [commentHeader] ++ [submapDecl] ++ childBindings ++ escapeBindings ++ [submapClose];

    # Generate all submaps (only regular keygroups, not default)
    regularSubmapLines = lib.concatMap generateSubmap regularKeygroups;
    
    # Generate default global bindings
    defaultBindingLines = generateDefaultBindings defaultKeygroups;
    
    # Combine default bindings and regular submaps
    allLines = defaultBindingLines ++ regularSubmapLines;
  in {
    wayland.windowManager.hyprland = {
      extraConfig = lib.concatStringsSep "\n" allLines;
    };
  };
}
