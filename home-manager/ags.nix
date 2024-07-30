{ inputs, pkgs, ... }: {

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  # Requires 'boot.kernelModules = [ "i2c-dev" ];' in system config to work

  home.packages = with pkgs; [
    ollama
    pywal
    ddcutil
    python3
    python3Packages.materialyoucolor
    python3Packages.pywayland
    python3Packages.pillow
    brightnessctl
    material-symbols
    morewaita-icon-theme
    gradience
    libnotify
    sass
    xdg-user-dirs
    yad
    bc
  ];

  programs.ags = {
    enable = true;
    configDir = null;

    extraPackages = with pkgs; [
      gtksourceview
      gtksourceview4
      ollama
      pywal
      webkitgtk
      webp-pixbuf-loader
      ydotool
      glib
      gjs
      gtk3
      gobject-introspection
      meson
      typescript
      libpulseaudio
      libnotify
      libdbusmenu-gtk3
      gtk-layer-shell
    ];
  };
}
