{pkgs, ...}: {
  home.packages = [
    pkgs.pyprland
  ];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = ["scratchpads"]

    [scratchpads.term]
    command = "${pkgs.kitty}/bin/kitty --class kitty-dropterm"
    animation = "fromTop"

    [scratchpads.secrets]
    command = "${pkgs.keepassxc}/bin/keepassxc"
    animation = "fromTop"
  '';

  wayland.windowManager.hyprland.settings.windowrulev2 = let
    kitty-dropterm = "class:^(kitty-dropterm)$";
    secrets = "class:^(org.keepassxc.KeePassXC)$";
  in [
    "float,${kitty-dropterm}"
    "size 40% 40%,${kitty-dropterm}"
    "workspace special silent,${kitty-dropterm}"
    "center,${kitty-dropterm}"

    "float,${secrets}"
    "size 40% 40%,${secrets}"
    "workspace special silent,${secrets}"
    "center,${secrets}"
  ];
}
