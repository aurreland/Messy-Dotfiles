{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [
    #godot_4
    godot3
    godot3-headless
    blender
  ];
}
