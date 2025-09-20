{
  config,
  namespace,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.${namespace}.development) infra;
  inherit (lib)
    mkIf
    mkEnableOption
    ;
in
{
  options.${namespace}.development.infra = {
    enable = mkEnableOption "Enable related tools";
  };
  config = mkIf infra.enable {
    home.packages = with pkgs; [
      awscli2
      aws-vault
      eksctl
      kubectl
      k9s
      helm
      terraform
      chamber
    ];
  };
}
