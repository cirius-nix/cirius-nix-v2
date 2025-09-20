{
  ...
}:
let
  namespace = "cirius-v2";
in
{
  config = {
    "${namespace}" = {
      term.alacritty = {
        enable = true;
      };
      stylix = {
        enable = true;
        wallpaper = ./wallpaper.jpg;
      };
      hyprland = {
        aliases = {
          mod = "SUPER";
          browser = "MOZ_LEGACY_PROFILES=1 zen";
          privateBrowser = "MOZ_LEGACY_PROFILES=1 zen --private-window";
          terminal = "alacritty";
          fileManager = "alacritty -e nnn";
          menu = "walker";
          ai = ''alacritty -e tgpt --interactive-shell'';
        };
      };
      security = {
        enable = true;
      };
      ai = {
        gemini = {
          enable = true;
        };
      };
      #   stylix = {
      #     enable = true;
      #     wallpaper = ./wallpaper.jpg;
      #   };
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
  };
}
