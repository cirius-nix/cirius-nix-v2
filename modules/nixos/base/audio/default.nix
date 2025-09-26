{ pkgs, ... }:
{
  # stylix.targets.cavalier.enable = true;
  environment.systemPackages = [
    pkgs.wiremix
  ];
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    extraConfig = {
      pipewire."99-silent-bell.conf" = {
        "context.properties" = {
          module.x11.bell = false;
        };
      };
    };
  };
}
