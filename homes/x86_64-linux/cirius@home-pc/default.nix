{
  pkgs,
  ...
}:
let
  namespace = "cirius-v2";
in
{
  config = {
    "${namespace}" = {
      picture = {
        krita.enable = true;
        gimp.enable = true;
      };
      explorer.nautilus.enable = true;
      term.alacritty = {
        enable = true;
      };
      stylix = {
        enable = true;
        wallpaper = ../../../assets/wallpaper-3.jpg;
      };
      hyprland = {
        packages = {
          icon = pkgs.beauty-line-icon-theme;
        };
        plugins = {
          waybar.enable = true;
          mako.enable = true;
          walker.enable = true;
          grimshot.enable = true;
          grimshot.editor = "krita";
        };
        aliases = {
          mod = "SUPER";
          launchBrowser = "zen";
          launchPrivateBrowser = "zen --private-window";
          launchTerminal = "alacritty";
          launchFileManager = "nautilus";
          launchMenu = "walker";
          launchAI = ''zen --new-window https://copilot.microsoft.com'';
        };
      };
      security = {
        enable = true;
      };
      ai = {
        copilot = {
          enable = true;
        };
        gemini = {
          enable = true;
        };
      };
      nix.enable = true;
      browser.zen-browser = {
        enable = true;
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
      development = {
        api-client = {
          apidog.enable = true;
        };
        git = {
          enable = true;
        };
        command-line = {
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
        editors = {
          datagrip.enable = true;
          nixvim = {
            enable = true;
            enableCopilotCompletion = true;
            ai = true;
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
  };
}
