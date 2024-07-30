{pkgs, ...}: {
  home.packages = with pkgs; [
    heroic
    steam
  ];
}
