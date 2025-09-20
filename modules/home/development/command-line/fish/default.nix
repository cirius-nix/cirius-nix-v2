{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkMerge
    types
    foldl'
    recursiveUpdate
    mapAttrsToList
    concatStringsSep
    concatMapStringsSep
    ;
  inherit (types)
    attrsOf
    listOf
    str
    submodule
    ;
  inherit (config.${namespace}.dev) lang;
  inherit (config.${namespace}.development.command-line) fish;
in
{
  options.${namespace}.development.command-line.fish = {
    enable = mkEnableOption "Enable fish shell";
    aliases = mkOption {
      type = attrsOf str;
      default = { };
      description = "Shell command aliases";
    };
    interactiveEnvs = mkOption {
      type = attrsOf str;
      default = { };
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
            default = [ ];
            description = "Arguments to pass to command";
          };
        };
      });
      default = { };
      description = "List of command going to run in interactive shell";
    };
    interactiveFuncs = mkOption {
      type = attrsOf str;
      default = { };
      description = "List of function to be created in interactive shell";
    };
    paths = mkOption {
      type = listOf str;
      default = [ ];
      description = "Append new paths to $PATH";
    };
  };
  config = mkIf fish.enable {
    programs.fish = {
      enable = true;
      shellAliases = mkMerge [
        {
          "g" = "git";
        }
        fish.aliases
      ];
      interactiveShellInit =
        let
          # env conversion.
          envs = foldl' recursiveUpdate { } [ fish.interactiveEnvs ];
          mkEnv = name: value: "set -gx ${name} ${value}";
          # func conversion.
          fns = foldl' recursiveUpdate { } [ fish.interactiveFuncs ];
          mkFn = name: body: ''
            function ${name}
              ${body}
            end
          '';
          # paths conversion.
          paths = (
            lib.unique (
              builtins.concatLists [
                [ "$HOME/.local/bin" ]
                fish.paths
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
          cmds = foldl' recursiveUpdate { } [ fish.interactiveCMDs ];
          mkArgs = args: concatStringsSep " " (lib.filter (x: x != "" && x != null) args);
          mkCmd = cmd: ''
            if type -q ${cmd.command}
              ${cmd.command} ${mkArgs cmd.args}
            end
          '';
        in
        ''
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
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "master";
            sha256 = "sha256-emmjTsqt8bdI5qpx1bAzhVACkg0MNB/uffaRjjeuFxU=";
          };
        }
      ]
      ++ (lib.optional lang.nodejs.enable {
        name = "nvm";
        inherit (pkgs.fishPlugins.nvm) src;
      });
    };
  };
}
