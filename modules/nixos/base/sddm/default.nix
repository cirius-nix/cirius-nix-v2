{ pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.sddm-astronaut
    ];
    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = [
        pkgs.sddm-astronaut
      ];
    };
  };
}
