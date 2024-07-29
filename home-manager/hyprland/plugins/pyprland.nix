{ pkgs-stable, ... }: {

  home.packages = [
    pkgs-stable.pyprland
  ];

  home.file.".config/hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = ["scratchpads"]

      [scratchpads.term]
      command = "kitty --class kitty-dropterm"
      animation = "fromTop"
    '';

  wayland.windowManager.hyprland.settings = {
    bind = [
      "Super Shift, T, exec, pypr toggle term"
    ];

    windowrulev2 = let
      kitty-dropterm = "class:^(kitty-dropterm)$";
    in [
      "float,${kitty-dropterm}"
      "size 40% 40%,${kitty-dropterm}"
      "workspace special silent,${kitty-dropterm}"
      "center,${kitty-dropterm}"

      "float,${kitty-dropterm}"
      "size 40% 80%,${kitty-dropterm}"
      "workspace special silent,${kitty-dropterm}"
    ];
  };
}
