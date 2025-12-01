{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [libgcc gccgo15];
  };
}
