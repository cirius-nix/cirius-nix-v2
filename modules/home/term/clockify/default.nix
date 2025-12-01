{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.term.clockify = let
    inherit (lib.${namespace}) strlib;
  in {
    enable = lib.mkEnableOption "Enable Clockify time tracker";
    secretKeys = {
      token = strlib.mkOption "clockify/token" "SOPS key for Clockify API token.";
      userID = strlib.mkOption "clockify/user_id" "SOPS key for Clockify user ID.";
      workspaceID = strlib.mkOption "clockify/workspace_id" "SOPS key for Clockify workspace ID.";
    };
    settings = {
      workweekDays = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = ["monday" "tuesday" "wednesday" "thursday" "friday"];
        description = "List of workweek days.";
      };
    };
  };
  config = let
    fishCfg = config.${namespace}.term.fish;
    drv = pkgs.nur.repos.lucassabreu.clockify-cli;
    clockifyCfg = config.${namespace}.term.clockify;
    configFile = config.snowfallorg.user.home.directory + "/.clockify-cli.yaml";
  in
    lib.mkIf config.${namespace}.term.clockify.enable {
      home.packages = [drv pkgs.clockify];
      programs.fish.interactiveShellInit = lib.mkIf fishCfg.enable ''
        ${drv}/bin/clockify-cli completion fish | source
      '';

      sops.templates."${namespace}/${config.snowfallorg.user.name}:${configFile}" = {
        path = configFile;
        content = ''
          allow-archived-tags: false
          allow-incomplete: true
          allow-name-for-id: true
          allow-project-name: true
          description-autocomplete: true
          description-autocomplete-days: 0
          interactive: true
          interactive-page-size: 7
          lang: en
          log-level: none
          search-project-with-client: true
          show-client: false
          show-task: false
          show-total-duration: false
          time-zone: Local
          token: ${config.sops.placeholder."${clockifyCfg.secretKeys.token}"}
          user:
              id: ${config.sops.placeholder."${clockifyCfg.secretKeys.userID}"}
          workspace: ${config.sops.placeholder."${clockifyCfg.secretKeys.workspaceID}"}
          workweek-days: [${lib.concatStringsSep ", " clockifyCfg.settings.workweekDays}]
        '';
      };
    };
}
