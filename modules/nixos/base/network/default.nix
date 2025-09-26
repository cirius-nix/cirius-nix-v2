{ pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.impala
      pkgs.curl
      pkgs.wget
    ];
  };
}
