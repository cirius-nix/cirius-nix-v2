{ pkgs, ... }:
{
  config = {
    environment.systemPackages = [ pkgs.tgpt ];
  };
}
