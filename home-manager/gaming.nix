{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages =
    (with pkgs; [
      heroic
    ])
    ++ (with pkgs-stable; [
      steam
    ]);
}
