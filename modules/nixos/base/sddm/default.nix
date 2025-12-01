{
  config,
  pkgs,
  lib,
  namespace,
  ...
}: {
  options.${namespace}.base.sddm = {
    enable = lib.mkEnableOption "Enable and configure SDDM display manager with astronaut theme.";
    embeddedTheme = lib.mkOption {
      type = lib.types.enum [
        "astronaut"
        "black_hole"
        "cyberpunk"
        "hyprland_kath"
        "jake_the_dog"
        "japanese_aesthetic"
        "pixel_sakura"
        "pixel_sakura_static"
        "post-apocalyptic_hacker"
        "purple_leaves"
      ];
      default = "jake_the_dog";
      description = "SDDM theme to use.";
    };
  };
  config = lib.mkIf config.${namespace}.base.sddm.enable (let
    # View derivation: nix edit nixpkgs#sddm-astronaut
    # INFO: test mode sddm-greeter-qt6 --test-mode --theme /run/current-system/sw/share/sddm/themes/sddm-astronaut-theme
    themePkg = (pkgs.sddm-astronaut.override
      {
        inherit (config.${namespace}.base.sddm) embeddedTheme;
      }).overrideAttrs (old: {
      installPhase =
        old.installPhase
        + ''
          echo ">>> Copying theme fonts..."
          mkdir -p $out/share/fonts
          cp -r $src/Fonts/* $out/share/fonts/
        '';
    });
  in {
    environment.systemPackages = [
      themePkg
    ];
    services.displayManager.sddm = {
      enable = true;
      package = lib.mkDefault pkgs.kdePackages.sddm;
      wayland.enable = true;
      # theme = "sddm-astronaut-theme";
      # extraPackages = [
      #   themePkg
      # ];
    };
    fonts.packages = [themePkg];
  });
}
