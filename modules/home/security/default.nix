{pkgs, ...}: {
  config = {
    home.packages = with pkgs; [
      age
      sops
      ssh-to-age
      openssl
    ];
  };
}
