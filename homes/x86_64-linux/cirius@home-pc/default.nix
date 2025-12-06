{
  config,
  lib,
  ...
}: let
  namespace = "cirius-v2";
  inherit (config.snowfallorg) user;
in {
  imports = [
    ./kde/default.nix
    ./secrets/default.nix
  ];
  # Global options for this namespace
  options.${namespace} = let
    inherit (lib.${namespace}) strlib;
  in {
    gitConfig = let
      subGitConfigType = lib.types.submodule {
        options = {
          dir = strlib.mkOption "" "Path to git config directory.";
          configFile = strlib.mkOption "" "Path to git config file.";
        };
      };
      workDir = "${user.home.directory}/Workspaces/github.com/work/";
      personalDir = "${user.home.directory}/Workspaces/github.com/personal/";
    in {
      work = lib.mkOption {
        type = subGitConfigType;
        default = {
          dir = workDir;
          configFile = "${workDir}/.gitconfig";
        };
        description = "Git config for work repositories.";
      };
      personal = lib.mkOption {
        type = subGitConfigType;
        default = {
          dir = personalDir;
          configFile = "${personalDir}/.gitconfig";
        };
        description = "Git config for personal repositories.";
      };
    };
  };

  config = {
    "${namespace}" = {
      ai = lib.${namespace}.enableAll ["lmstudio" "ollama" "copilot" "gemini"] {
        ollama.port = 11434;
      };
      note = lib.${namespace}.enableAll ["obsidian"] {};
      picture = lib.${namespace}.enableAll ["krita"] {};
      term = lib.${namespace}.enableAll ["sysMonitor" "starship" "clockify" "zoxide" "atuin" "alacritty" "fish" "zellij" "fzf" "direnv" "taskfile" "devenv"] {
        fish.aliases = {
          "rbnix" = "sudo nixos-rebuild switch";
          "gaa" = "git add .";
          "gst" = "git status";
          "gpl" = "git pull origin";
          "gps" = "git push origin";
        };
        clockify.secretKeys = {
          token = "work/clockify/token";
          userID = "work/clockify/user_id";
          workspaceID = "work/clockify/workspace_id";
        };
      };
      stylix = {
        enable = true;
        wallpaper = ../../../assets/wallpaper-4.jpg;
      };
      nix = lib.${namespace}.enableAll ["cachix"] {
        cachix.secretKeys = {
          authToken = "personal/cachix/auth_token";
        };
      };
      browser = lib.${namespace}.enableAll ["chrome" "zen-browser"] {
        zen-browser = {
          containers = [
            {
              id = 2;
              name = "Buuuk";
              icon = "briefcase";
              color = "orange";
              spaceID = "d418a329-32a1-47fe-9f61-8e7c297a9f69";
              spacePosition = 2000;
              spaceIcon = "";
            }
          ];
        };
      };
      development = lib.${namespace}.enableAll ["docker" "git"] {
        git.includeConfigs = [
          {
            condition = "gitdir:${config.${namespace}.gitConfig.work.dir}";
            path = config.${namespace}.gitConfig.work.configFile;
          }
          {
            condition = "gitdir:${config.${namespace}.gitConfig.personal.dir}";
            path = config.${namespace}.gitConfig.personal.configFile;
          }
        ];
        api-client = lib.${namespace}.enableAll ["apidog"] {};
        infra = {
          cloud = lib.${namespace}.enableAll ["aws"] {
            aws = {
              configPlaceholders = ["work/aws/config" "personal/aws/config"];
            };
          };
          iac = lib.${namespace}.enableAll ["terraform" "pulumi"] {};
        };
        editors = lib.${namespace}.enableAll ["antigravity" "datagrip" "code" "nixvim"] {
          nixvim = {
            enableCopilotCompletion = true;
            ai = true;
            plugins.explorer.alwaysShow = [".sops.yaml" "provision.pg.sql" "mockery.yml"];
          };
        };
        lang = lib.${namespace}.enableAll ["terraform" "nix" "nodejs" "go" "shell"] {};
      };
    };
  };
}
