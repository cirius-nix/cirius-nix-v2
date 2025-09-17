{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  tf = config.${namespace}.dev.lang.terraform;
in
{
  options.${namespace}.dev.lang.terraform = {
    enable = mkEnableOption "Enable Terraform Language Support";
  };
  config = mkIf tf.enable {
    home.packages = with pkgs; [
      terraform
      terraform-ls
      tflint
      tfsec
    ];
  };
}
