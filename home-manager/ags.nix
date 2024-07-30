{ inputs, pkgs, ... }: {

  imports = [
    inputs.ags.homeManagerModules.default
  ];

  # Requires 'boot.kernelModules = [ "i2c-dev" ];' in system config to work

  home.packages = with pkgs; [
    ddcutil
    brightnessctl
    material-symbols
    morewaita-icon-theme
    gradience
    sass
  ];

  programs.ags = {
    enable = true;
    configDir = null;

    extraPackages = with pkgs; [
      gtksourceview
      gtksourceview4
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
