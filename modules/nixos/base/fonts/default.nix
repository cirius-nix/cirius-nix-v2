{
  pkgs,
  ...
}:
{
  fonts.packages = [
    pkgs.nerd-fonts.iosevka
    pkgs.nerd-fonts.meslo-lg
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.caskaydia-mono
  ];
}
