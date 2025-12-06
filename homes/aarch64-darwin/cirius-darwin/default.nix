{
  config,
  lib,
  ...
}: let
  namespace = "cirius-v2";
  inherit (config.snowfallorg) user;
in {
  imports = [
    ./secrets/default.nix
  ];
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
  config = let
    inherit (lib.${namespace}) enableAll;
  in {
    ${namespace} = {
      term = enableAll ["sysMonitor" "starship" "clockify" "zoxide" "atuin" "alacritty" "fish" "zellij" "fzf" "direnv" "taskfile" "devenv"] {
        fish.aliases = {
          "rbnix" = "sudo darwin-rebuild switch --flake .#${user.username}";
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
    };
    development = enableAll ["git"] {
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
      infra = {
        cloud = lib.${namespace}.enableAll ["aws"] {
          aws = {
            configPlaceholders = ["work/aws/config" "personal/aws/config"];
          };
        };
        iac = lib.${namespace}.enableAll ["terraform" "pulumi"] {};
      };
      editors = lib.${namespace}.enableAll ["antigravity" "code" "nixvim"] {
        nixvim = {
          enableCopilotCompletion = true;
          ai = true;
          plugins.explorer.alwaysShow = [".sops.yaml" "provision.pg.sql" "mockery.yml"];
        };
      };
      lang = lib.${namespace}.enableAll ["terraform" "nix" "nodejs" "go" "shell"] {};
    };
  };
}
