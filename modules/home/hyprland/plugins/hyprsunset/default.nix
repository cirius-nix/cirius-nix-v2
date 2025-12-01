{
  namespace,
  lib,
  ...
}@inputs:
lib.${namespace}.hyprland.applyAttrOnEnabled inputs {
  config = {
    services.hyprsunset = {
      enable = true;
      settings = {
        profile = [
          {
            time = "7:30";
            identity = true;
          }
          {
            time = "20:00";
            temperature = 5000;
            gamma = 0.8;
          }
        ];
      };
    };
  };
}
