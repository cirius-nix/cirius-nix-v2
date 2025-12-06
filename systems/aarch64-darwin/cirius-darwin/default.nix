{namespace, ...}: let
  users = {
    cirius-darwin = {
      name = "cirius-darwin";
    };
  };
in {
  config = {
    ${namespace} = {
    };
    home-manager = {
      useGlobalPkgs = true;
      backupFileExtension = "backup";
      users = {
        ${users.cirius-darwin.name}.home.stateVersion = "25.05";
      };
    };
    system.stateVersion = "24.05";
  };
}
