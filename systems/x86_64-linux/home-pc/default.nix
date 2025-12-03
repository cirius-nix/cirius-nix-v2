{
  pkgs,
  namespace,
  inputs,
  config,
  lib,
  ...
}: let
  hostName = "home-pc";
  shellName = "fish";
  users = {
    cirius = {
      name = "cirius";
      isNormalUser = true;
      shell = pkgs.${shellName};
      extraGroups = [
        "networkmanager"
        "wheel"
        "podman"
      ];
    };
  };
  # autologinUser = users.cirius.name;
  autologinUser = null;
in {
  imports = [
    ./hardware-configuration.nix
  ];
  config = {
    # Org Cirius Group
    users.groups."org.cirius" = {
      gid = 3000;
      members = [users.cirius.name];
    };
    sops.secrets =
      {
        "postgres/hostDB/admin_password" = {
          sopsFile = ../../../secrets/org.cirius/personal.yaml;
        };
      }
      // {
        "infisical/redis/password" = {
          sopsFile = ../../../secrets/org.cirius/infisical/default.yaml;
          key = "redis/password";
        };
        "infisical/env" = {
          sopsFile = ../../../secrets/org.cirius/infisical/default.yaml;
          key = "env";
        };
      };
    #################################
    # Localization and Timezone
    # ###############################
    time.timeZone = "Asia/Ho_Chi_Minh";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "vi_VN";
        LC_IDENTIFICATION = "vi_VN";
        LC_MEASUREMENT = "vi_VN";
        LC_MONETARY = "vi_VN";
        LC_NAME = "vi_VN";
        LC_NUMERIC = "vi_VN";
        LC_PAPER = "vi_VN";
        LC_TELEPHONE = "vi_VN";
        LC_TIME = "vi_VN";
      };
    };
    #################################
    # Nix Settings
    # ###############################
    nix = {
      settings.trusted-users = [
        "root"
        users.cirius.name
      ];
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];
      package = pkgs.lixPackageSets.stable.lix;
    };
    system.stateVersion = "25.05";
    #################################
    # Namespace Configuration
    # ###############################
    ${namespace} = {
      base = lib.${namespace}.enableAll ["rsync" "input-method" "fonts" "bluetooth"] {
        enable = true;
        rsync = {
          port = 3873;
        };
        input-method = {
          addons = with pkgs; [
            kdePackages.fcitx5-qt
            fcitx5-bamboo
            qt6Packages.fcitx5-unikey
          ];
        };
        network = {inherit hostName;};
        security = lib.${namespace}.enableAll ["gnupg" "infisical"] {
          # currently no need to use infisical.
          infisical = {
            enable = false;
            port = 8034;
            envFile = config.sops.secrets."infisical/env".path;
            redis = {
              port = 6380;
              passFile = config.sops.secrets."infisical/redis/password".path;
            };
          };
        };
        database = lib.${namespace}.enableAll ["postgres" "neo4j"] {
          postgres = {
            package = pkgs.postgresql_18;
            adminPasswordPath = "postgres/hostDB/admin_password";
            extensions = with pkgs; [
              postgresql18Packages.postgis
              postgresql18Packages.pgvector
            ];
            settings = {
              port = 5400;
            };
          };
        };
        user = {inherit users autologinUser;};
        hardware = lib.${namespace}.enableAll ["nvidia" "ntfs"] {
          nvidia.enableUtilities = true;
        };
      };
      shell = lib.${namespace}.enableAll [shellName] {};
      wsl.enable = false;
      de = lib.${namespace}.enableAll ["kde"] {
        kde.enable = true;
      };
      security = lib.${namespace}.enableAll ["enpass" "fail2ban"] {
        enpass.enable = true;
      };
      network = lib.${namespace}.enableAll ["adguardhome"] {
        # FIXME: collision with docker.
        adguardhome.settings.port = 3200;
      };
      dev = {
        docker.enable = true;
        sonarqube.enable = true;
      };
    };
    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      users = {
        ${users.cirius.name}.home.stateVersion = "25.05";
      };
    };
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
