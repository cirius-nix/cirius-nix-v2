{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: {
  options.${namespace}.term.fish = let
    inherit (lib) types mkEnableOption mkOption;
    inherit (types) attrsOf listOf str submodule;
  in {
    enable = mkEnableOption "Enable fish shell";
    aliases = mkOption {
      type = attrsOf str;
      default = {};
      description = "Shell command aliases";
    };
    interactiveEnvs = mkOption {
      type = attrsOf str;
      default = {};
      description = "Set environment variables in interactive shell";
    };
    interactiveCMDs = mkOption {
      type = attrsOf (submodule {
        options = {
          command = mkOption {
            type = str;
            description = "Command to run";
          };
          args = mkOption {
            type = listOf str;
            default = [];
            description = "Arguments to pass to command";
          };
        };
      });
      default = {};
      description = "List of command going to run in interactive shell";
    };
    interactiveFuncs = mkOption {
      type = attrsOf str;
      default = {};
      description = "List of function to be created in interactive shell";
    };
    paths = mkOption {
      type = listOf str;
      default = [];
      description = "Append new paths to $PATH";
    };
  };
  config = let
    inherit (lib) mkIf mkMerge foldl' recursiveUpdate mapAttrsToList concatStringsSep concatMapStringsSep;
    cfg = (config.${namespace}.term).fish;
  in
    mkIf cfg.enable {
      programs.fish = {
        enable = true;
        shellAliases = mkMerge [
          {
            "g" = "git";
          }
          cfg.aliases
        ];
        interactiveShellInit = let
          # env conversion.
          envs = foldl' recursiveUpdate {} [cfg.interactiveEnvs];
          mkEnv = name: value: "set -gx ${name} ${value}";
          # func conversion.
          fns = foldl' recursiveUpdate {} [cfg.interactiveFuncs];
          mkFn = name: body: ''
            function ${name}
              ${body}
            end
          '';
          # paths conversion.
          paths = (
            lib.unique (
              builtins.concatLists [
                ["$HOME/.local/bin"]
                cfg.paths
              ]
            )
          );
          mkPath = path: ''
            if test -d ${path}
              if not contains ${path} $PATH
                set -p PATH ${path}
              end
            end
          '';
          # cmds conversion.
          cmds = foldl' recursiveUpdate {} [cfg.interactiveCMDs];
          mkArgs = args: concatStringsSep " " (lib.filter (x: x != "" && x != null) args);
          mkCmd = cmd: ''
            if type -q ${cmd.command}
              ${cmd.command} ${mkArgs cmd.args}
            end
          '';
        in ''
          set fish_greeting "";
          ${concatStringsSep "\n" (mapAttrsToList mkEnv envs)}
          ${concatStringsSep "\n" (mapAttrsToList mkFn fns)}
          ${concatMapStringsSep "\n" mkPath paths}
          ${concatStringsSep "\n" (map mkCmd (lib.attrValues cmds))}
        '';
        plugins = [
          {
            name = "autopair";
            inherit (pkgs.fishPlugins.autopair) src;
          }
          {
            name = "bass";
            inherit (pkgs.fishPlugins.bass) src;
          }
          {
            name = "fish-ssh";
            src = pkgs.fetchFromGitHub {
              owner = "danhper";
              repo = "fish-ssh-agent";
              rev = "master";
              sha256 = "sha256-cFroQ7PSBZ5BhXzZEKTKHnEAuEu8W9rFrGZAb8vTgIE=";
            };
          }
        ];
      };
    };
}
