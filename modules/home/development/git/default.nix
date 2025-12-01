{
  config,
  namespace,
  lib,
  pkgs,
  options,
  ...
}: {
  options.${namespace}.development.git = let
    inherit (lib) mkEnableOption mkOption types;
  in {
    enable = mkEnableOption "Enable Git";
    includeConfigs = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "List of paths to git config files to include";
    };
    includes = options.programs.git.includes;
  };
  config = let
    gitCfg = (config.${namespace}.development).git;
  in
    lib.mkIf gitCfg.enable {
      home.packages = [];
      stylix.targets.lazygit.enable = true;
      programs = lib.${namespace}.enableAll ["git" "gh" "lazygit"] {
        fish = {
          interactiveShellInit = ''
            source ${./extra/copilot-fn.fish}
          '';
        };
        git = {
          includes = gitCfg.includeConfigs;
          settings = {
            aliases = {
              undo = "reset HEAD~1 --mixed";
              amend = "commit -a --amend";
              prv = "!gh pr view";
              prc = "!gh pr create";
              prs = "!gh pr status";
              prm = "!gh pr merge -d";
              pl = "pull";
              ps = "push";
              co = "checkout";
              aa = "add .";
              st = "status";
            };
            extraConfig = {
              core.whitespace = "trailing-space,space-before-tab";
              init.defaultBranch = "main";
              push.autoSetupRemote = true;
              color.ui = "auto";
              diff = {
                tool = "vimdiff";
                mnemonicprefix = true;
              };
              merge.tool = "splice";
              push.default = "simple";
              pull.rebase = true;
              branch.autosetupmerge = true;
              rerere.enabled = true;
            };
          };
        };
        gh = {
          extensions = [
            pkgs.gh-copilot
            pkgs.gh-eco
          ];
          gitCredentialHelper = {
            enable = true;
            hosts = ["https://github.com"];
          };
          settings = {
            editor = lib.getExe pkgs.neovim;
            prompt = "enabled";
            git_protocol = "ssh";
          };
        };
      };
    };
}
