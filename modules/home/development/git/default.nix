{
  config,
  namespace,
  lib,
  pkgs,
  options,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    getExe
    ;
  inherit (lib.${namespace}) flatDist;
  inherit (config.${namespace}.development) git;
  inherit (git.plugins) opencommit;
in
{
  options.${namespace}.development.git = {
    enable = mkEnableOption "Enable Git";
    includeConfigs = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "List of paths to git config files to include";
    };
    includes = options.programs.git.includes;
    plugins = {
      opencommit = {
        enable = mkEnableOption "Enable opencommit git plugin";
        provider = mkOption {
          type = types.enum [
            "openai"
            "gemini"
          ];
          default = "openai";
          description = "Provider for opencommit git plugin";
        };
        model = mkOption {
          type = types.str;
          default = "gpt-4o-mini";
          description = "Model for opencommit git plugin";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.opencommit;
          description = "Package for opencommit git plugin";
        };
      };
    };
    sopsIntegration = {
      enable = mkEnableOption "Enable SOPS integration for managing .opencommit_config";
    };
  };
  config = mkIf git.enable {
    home.packages = flatDist [
      (lib.optional opencommit.enable opencommit.package)
    ];
    sops.templates = mkIf git.sopsIntegration.enable {
      ".opencommit_config" = {
        mode = "0660";
        path = "${config.snowfallorg.user.home.directory}/.opencommit";
        content = ''
          OCO_TOKENS_MAX_INPUT=4096
          OCO_TOKENS_MAX_OUTPUT=500
          OCO_DESCRIPTION=false
          OCO_EMOJI=false
          OCO_MODEL=gpt-4o-mini
          OCO_LANGUAGE=en
          OCO_MESSAGE_TEMPLATE_PLACEHOLDER=$msg
          OCO_PROMPT_MODULE=conventional-commit
          OCO_AI_PROVIDER=${git.plugins.opencommit.provider}
          OCO_ONE_LINE_COMMIT=false
          OCO_TEST_MOCK_TYPE=commit-message
          OCO_WHY=false
          OCO_OMIT_SCOPE=false
          OCO_GITPUSH=true
          OCO_HOOK_AUTO_UNCOMMENT=false
        '';
      };
    };
    programs.git = {
      enable = true;
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
      includes = git.includeConfigs;
      extraConfig = {
        core.whitespace = "trailing-space,space-before-tab";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        color = {
          ui = "auto";
        };
        diff = {
          tool = "vimdiff";
          mnemonicprefix = true;
        };
        merge = {
          tool = "splice";
        };
        push = {
          default = "simple";
        };
        pull = {
          rebase = true;
        };
        branch = {
          autosetupmerge = true;
        };
        rerere = {
          enabled = true;
        };
      };
    };
    programs.gh = {
      enable = true;
      extensions = [ ];
      gitCredentialHelper = {
        enable = true;
        hosts = [ "https://github.com" ];
      };
      settings = {
        editor = getExe pkgs.neovim;
        prompt = "enabled";
        git_protocol = "ssh";
      };
    };
    stylix.targets.lazygit.enable = true;
    programs.lazygit = {
      enable = true;
      settings = {
      };
    };
  };
}
