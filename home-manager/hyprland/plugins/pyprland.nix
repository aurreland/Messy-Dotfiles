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

      [scratchpads.secrets]
      command = "secrets"
      animation = "fromTop"
    '';

  wayland.windowManager.hyprland.settings.windowrulev2 = let
    kitty-dropterm = "class:^(kitty-dropterm)$";
    secrets = "class:^(org.gnome.World.Secrets)$";
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
