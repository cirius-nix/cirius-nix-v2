{
  config,
  host,
  lib,
  ...
}: let
  namespace = "cirius-v2";
  inherit (config.snowfallorg) user;
in {
  config = {
    sops = {
      age = {
        keyFile = "${user.home.directory}/.config/sops/age/keys.txt";
      };
      defaultSopsFile = ../../../../secrets/${host}/${user.name}/default.yaml;
      defaultSopsFormat = "yaml";
      secrets = let
        orgOwner = "org.cirius";
        secretPathPrefix = ../../../../secrets/${orgOwner};
        workPath = lib.path.append secretPathPrefix "work.yaml";
        personalPath = lib.path.append secretPathPrefix "personal.yaml";

        mkCommonSecrets = target: sopsFile: {
          "${target}/ssh/prvkey" = {
            sopsFile = sopsFile;
            key = "ssh/private_key";
            path = "${config.snowfallorg.user.home.directory}/.ssh/${target}";
          };
          "${target}/ssh/pubkey" = {
            sopsFile = sopsFile;
            key = "ssh/public_key";
            path = "${config.snowfallorg.user.home.directory}/.ssh/${target}.pub";
          };
          "${target}/git/config" = {
            sopsFile = sopsFile;
            key = "git/config";
            path = config.${namespace}.gitConfig.${target}.configFile;
          };
        };

        workSecrets = let
          clockifyKeys = config.${namespace}.term.clockify.secretKeys;
        in
          {
            "${clockifyKeys.token}" = {
              sopsFile = workPath;
              key = "clockify/token";
            };
            "${clockifyKeys.userID}" = {
              sopsFile = workPath;
              key = "clockify/user_id";
            };
            "${clockifyKeys.workspaceID}" = {
              sopsFile = workPath;
              key = "clockify/workspace_id";
            };
          }
          // (mkCommonSecrets "work" workPath);

        personalSecrets =
          {
            "${config.${namespace}.nix.cachix.secretKeys.authToken}" = {
              sopsFile = personalPath;
              key = "cachix/auth_token";
            };
          }
          // (mkCommonSecrets "personal" personalPath);
      in
        workSecrets // personalSecrets;
    };
  };
}
