{
  pkgs,
  namespace,
  inputs,
  ...
}:
let
  hostname = "cirius-wsl";
in
{
  config = {
    ${namespace} = {
      shell.fish.enable = true;
      wsl = {
        enable = true;
        defaultUser = "cirius";
        inherit hostname;
      };
      security = {
        inherit hostname;
      };
      db.postgres = {
        enable = true;
        port = 5000;
      };
    };
    sops =
      let
        keyFile = "/var/lib/sops-nix/key.txt";
      in
      {
        defaultSopsFile = ../../../secrets/${hostname}/default.yaml;
        defaultSopsFormat = "yaml";
        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = keyFile;
        };
        secrets = { };
      };
    users.users = {
      "cirius" = {
        isNormalUser = true;
        shell = pkgs.fish;
        extraGroups = [ "wheel" ];
      };
    };
    home-manager = {
      useGlobalPkgs = true;
      users.cirius.home.stateVersion = "25.05";
    };
    nix = {
      settings.trusted-users = [
        "root"
        "cirius"
      ];
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    };
    system.stateVersion = "25.05";
  };
}
