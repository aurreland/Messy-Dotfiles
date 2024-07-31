{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [
    godot_4
    blender
    material
  ];
}
