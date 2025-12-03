{
  config,
  namespace,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption;
  inherit (lib.${namespace}) checkAnyEnabled;
in {
  options.${namespace}.development.infra = {
    cloud = {
      aws = {
        enable = mkEnableOption "Enable AWS related tools";
      };
    };
    k8s = {
      enable = mkEnableOption "Enable Kubernetes related tools";
    };
    iac = {
      terraform = {
        enable = mkEnableOption "Enable Terraform";
      };
      pulumi = {
        enable = mkEnableOption "Enable Pulumi";
      };
    };
  };
  config = let
    cfg = (config.${namespace}.development).infra;
  in {
    home.packages =
      (lib.optionals (checkAnyEnabled cfg.cloud) (with pkgs; [
        chamber
        helm
      ]))
      # IAC
      ++ (lib.optionals (checkAnyEnabled cfg.cloud) (
        (lib.optionals cfg.iac.terraform.enable (with pkgs; [
          terraform-ls
          terraform-docs
          tflint
          tfsec
        ]))
        ++ (lib.optionals cfg.iac.pulumi.enable (with pkgs; [
          pulumi
          pulumictl
          pulumi-esc
        ]))
      ))
      # aws
      ++ (
        (lib.optionals cfg.cloud.aws.enable (with pkgs; [
          aws-vault
          awscli2
          ssm-session-manager-plugin
        ]))
        ++ (lib.optionals config.programs.fish.enable (with pkgs; [
          fishPlugins.aws
        ]))
        ++ (lib.optionals (cfg.k8s.enable) (with pkgs; [
          eksctl
        ]))
      )
      # K8s
      ++ (lib.optionals cfg.k8s.enable (with pkgs; [
        kubectl
        k9s
        kustomize
        kubebuilder
        kind
      ]));
  };
}
