{
  config,
  host,
  ...
}:
let
  namespace = "cirius-v2";
  inherit (config.snowfallorg) user;
in
{
  config = {
    sops = {
      age = {
        keyFile = "${user.home.directory}/.config/sops/age/keys.txt";
      };
      defaultSopsFile = ../../../secrets/${host}/${user.name}/default.yaml;
      defaultSopsFormat = "yaml";
      secrets =
        let
          hostSecrets = {
            sopsFile = ../../../secrets/${host}/default.yaml;
          };
        in
        {
          "cachix_auth_token" = { };
          "gh/personal/access_token" = { };
          "ssh/work_private_key" = {
            mode = "0600";
            path = "${config.snowfallorg.user.home.directory}/.ssh/work";
          };
          "ssh/work_public_key" = {
            mode = "0600";
            path = "${config.snowfallorg.user.home.directory}/.ssh/work.pub";
          };
          "ai/gemini_api_key" = { };
          "ai/openai_api_key" = { };
          "db/postgres/databases/sonarqube/db/name" = {
            inherit (hostSecrets) sopsFile;
          };
          "db/postgres/databases/sonarqube/db/schema" = {
            inherit (hostSecrets) sopsFile;
          };
          "db/postgres/databases/sonarqube/users/writer/username" = {
            inherit (hostSecrets) sopsFile;
          };
          "db/postgres/databases/sonarqube/users/writer/password" = {
            inherit (hostSecrets) sopsFile;
          };
        };
    };
    ${namespace} = {
      security = {
        enable = true;
      };
      ai = {
        gemini = {
          enable = true;
        };
      };
      stylix = {
        enable = true;
        wallpaper = ./wallpaper.jpg;
      };
      nix.enable = true;
      dev = {

        sonarqube = {
          enable = true;
          postgresDB = { };
          settings = { };
        };
        cli = {
          stat.enable = true;
          fzf.enable = true;
          zoxide.enable = true;
          fish = {
            enable = true;
            aliases = {
              "rbnix" = "sudo nixos-rebuild switch";
              "gaa" = "git add .";
              "gst" = "git status";
              "gpl" = "git pull origin";
              "gps" = "git push origin";
            };
          };
          starship.enable = true;
          direnv.enable = true;
          taskfile.enable = true;
          zellij.enable = true;
          nnn.enable = true;
          devenv = {
            enable = true;
          };
        };
        infra.enable = true;
        git = {
          enable = true;
          plugins = {
            opencommit.enable = true;
          };
          includes = [
            {
              condition = "gitdir:~/Workspaces/github/work/";
              contents = {
                user = {
                  email = "hieu@buuuk.com";
                  name = "Minh Hieu Tran";
                };
                github = {
                  user = "hieu-buuuk";
                };
                core = {
                  sshCommand = "ssh -i ~/.ssh/work";
                };
              };
            }
            {
              condition = "gitdir:~/Workspaces/github/personal/";
              contents = {
                user = {
                  email = "hieu.tran21198@gmail.com";
                  name = "Minh Hieu Tran";
                };
                github = {
                  user = "hieutran21198";
                };
                core = {
                  sshCommand = "ssh -i ~/.ssh/cirius@cirius-wsl_ed25519";
                };
              };
            }
          ];
          includeConfigs = [
            {
              condition = "gitdir:~/Workspaces/github/work/";
              path = "~/.Workspaces/github/work/.gitconfig";
            }
            {
              condition = "gitdir:~/Workspaces/github/personal/";
              path = "~/.Workspaces/github/personal/.gitconfig";
            }
          ];
        };
        editor = {
          nixvim = {
            enable = true;
            enableCopilot = true;
          };
        };
        lang = {
          terraform.enable = true;
          nix.enable = true;
          nodejs = {
            enable = true;
          };
          go = {
            enable = true;
          };
          shell.enable = true;
        };
      };
    };
    home.stateVersion = "25.05";
  };
}
