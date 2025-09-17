{
  config = {
    programs.nixvim.plugins = {
      which-key = {
        enable = true;
        settings = {
          icon-mappings = false;
          preset = "helix";
          delay = 0;
          # currently issue with 0.11 version.
          # author seem not want to resolve it.
          show_help = false;
        };
      };
    };
  };
}
