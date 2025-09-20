{
  pkgs,
  namespace,
  inputs,
  ...
}:
let
  hostName = "home-pc";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  config = {
    ${namespace} = {
      base = {
        enable = true;
        input-method = {
          addons = [
            pkgs.kdePackages.fcitx5-qt
            pkgs.fcitx5-bamboo
            pkgs.fcitx5-unikey
          ];
        };
      };
      nvidia.enable = true;
      shell.fish.enable = true;
      wsl.enable = false;
      de.hyprland.enable = true;
      security = {
        enpass.enable = true;
      };
    };
    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      users = {
        cirius.home.stateVersion = "25.05";
      };
    };
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    networking = {
      inherit hostName;
      networkmanager.enable = true;
    };
    time.timeZone = "Asia/Ho_Chi_Minh";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
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
    services.getty.autologinUser = "cirius";
    users.users = {
      "cirius" = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
    nix = {
      settings.trusted-users = [
        "root"
        "cirius"
      ];
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      package = pkgs.lixPackageSets.stable.lix;
    };
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      kitty
      alacritty
      firefox
      neovim
      git
      gh
      gh-copilot
      fish
      wget
    ];
    system.stateVersion = "25.05";
  };
}
