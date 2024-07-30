{
  wayland.windowManager.hyprland.settings = {
    windowrule = let
      f = regex: "float, ^(${regex})$";
      wdr = option: title: "${option}, title:^(${title})$";
    in [
      "noblur,.*"
      (f "org.gnome.Calculator")
      (f "org.gnome.Nautilus")
      (f "pavucontrol")
      (f "nm-connection-editor")
      (f "blueberry.py")
      (f "org.gnome.Settings")
      (f "org.gnome.design.Palette")
      (f "Color Picker")
      (f "xdg-desktop-portal")
      (f "xdg-desktop-portal-gnome")
      (f "de.haeckerfelix.Fragments")
      (f "com.github.Aylur.ags")
      (f "xdg-desktop-portal-gtk")
      "float, title:^(Choose wallpaper)(.*)$"
      "immediate,.*\.exe"

      "workspace 5, title:Spotify"
    ];
    windowrulev2 = [
      "immediate,class:(steam_app)"
      "noshadow,floating:0"
    ];
    layerrule = [
      "xray 1, .*"
      "noanim, walker"
      "noanim, selection"
      "noanim, overview"
      "noanim, anyrun"
      "noanim, indicator.*"
      "noanim, osk"
      "noanim, hyprpicker"
      "blur, shell:*"
      "ignorealpha 0.6, shell:*"

      "noanim, noanim"
      "blur, gtk-layer-shell"
      "ignorezero, gtk-layer-shell"
      "blur, launcher"
      "ignorealpha 0.5, launcher"
      "blur, notifications"
      "ignorealpha 0.69, notifications"

      "animation slide top, sideleft.*"
      "animation slide top, sideright.*"
      "blur, session"

      "blur, bar"
      "ignorealpha 0.6, bar"
      "blur, corner.*"
      "ignorealpha 0.6, corner.*"
      "blur, dock"
      "ignorealpha 0.6, dock"
      "blur, indicator.*"
      "ignorealpha 0.6, indicator.*"
      "blur, overview"
      "ignorealpha 0.6, overview"
      "blur, cheatsheet"
      "ignorealpha 0.6, cheatsheet"
      "blur, sideright"
      "ignorealpha 0.6, sideright"
      "blur, sideleft"
      "ignorealpha 0.6, sideleft"
      "blur, indicator*"
      "ignorealpha 0.6, indicator*"
      "blur, osk"
      "ignorealpha 0.6, osk"
    ];
  };
}
