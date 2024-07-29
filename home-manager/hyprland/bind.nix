{
  inputs,
  pkgs,
  ...
}: let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;

  playerctl = "${pkgs.playerctl}/bin/playerctl";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  workspace_action = pkgs.writeShellScriptBin "workspace_action" ''
    ${hyprland}/bin/hyprctl dispatch "$1" $(((($(${hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r .id) - 1)  / 10) * 10 + $2))
  '';
in {

  home.packages = [ workspace_action ];

  wayland.windowManager.hyprland.settings = {

    binds = {
        allow_workspace_cycles = true;
      };

    bind = let
      binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
      workspaces = mod: cmd: key: arg: "${mod}, ${key}, exec, workspace_action ${cmd} ${arg}";
      mvfocus = binding "SUPER" "movefocus";
      ws = workspaces "SUPER" "workspace";
      mvtows = workspaces "SUPER SHIFT" "movetoworkspace";
      arr = [ "ampersand" "eacute" "quotedbl"  "apostrophe" "parenleft" "minus" "egrave" "underscore" "ccedilla" ];
    in [
      # General
        "Super, T, exec, kitty # [Essentials] Launch kitty (terminal)"
        ", Super, exec, true # [Essentials] Open App Launcher"
        "Control Super, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh # [Essentials] Change Wallpaper"
      # Actions
        "Super, E, exec, nautilus -w # [Actions] Launch Nautilus (file manager)"
      # Windows Management
        "Alt, A, killactive, # [Windows Management] Kills Active Window"
      # Windows Arrangement
        "Super, G, togglegroup # [Windows Arrangement] Enable Grouping for active Window"
        "Alt, Tab, changegroupactive, f # [Windows Arrangement] Cycle through the Windows of a Group"
        "Alt Control, Tab, changegroupactive, b"
        "Super Shift, G, moveoutofgroup, # [Windows Arrangement] Moves Active Window out of the Group"
        "Alt, Space, togglefloating, # [Windows Arrangement] Makes Active Window floats"
        "Super Alt, F, fakefullscreen,"
        "Super, F, fullscreen, 0 # [Windows Arrangement] Fullscreen with Bar"
        "Super, D, fullscreen, 1 # [Windows Arrangement] Total Fullscren"

        "Super Shift, A, exit"

        ''Control Shift, G, exec, for ((i=0; i<$(hyprctl monitors -j | jq length); i++)); do ags -t "crosshair""$i"; done''
        
        

        (mvfocus "Up" "u")
        (mvfocus "Down" "d")
        (mvfocus "Right" "r")
        (mvfocus "Left" "l")
    ]
    ++ map (i: ws (builtins.elemAt arr i) (toString (i + 1))) (builtins.genList (i: i) (builtins.length arr))
    ++ map (i: mvtows (builtins.elemAt arr i) (toString (i + 1))) (builtins.genList (i: i) (builtins.length arr));

    bindle = [
      ",XF86MonBrightnessUp,   exec, ${brightnessctl} set +5%"
      ",XF86MonBrightnessDown, exec, ${brightnessctl} set  5%-"
      ",XF86AudioRaiseVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ +5%"
      ",XF86AudioLowerVolume,  exec, ${pactl} set-sink-volume @DEFAULT_SINK@ -5%"
    ];

    bindl = [
      ",XF86AudioPlay,    exec, ${playerctl} play-pause"
      ",XF86AudioStop,    exec, ${playerctl} pause"
      ",XF86AudioPause,   exec, ${playerctl} pause"
      ",XF86AudioPrev,    exec, ${playerctl} previous"
      ",XF86AudioNext,    exec, ${playerctl} next"
      ",XF86AudioMicMute, exec, ${pactl} set-source-mute @DEFAULT_SOURCE@ toggle"
    ];

    binde = let
      binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
      resizeactive = binding "SUPER CTRL" "resizeactive";
      mvactive = binding "SUPER ALT" "moveactive";
    in [
      (resizeactive "Up" "0 -20")
      (resizeactive "Down" "0 20")
      (resizeactive "Right" "20 0")
      (resizeactive "left" "-20 0")
      (mvactive "Up" "0 -20")
      (mvactive "Down" "0 20")
      (mvactive "Right" "20 0")
      (mvactive "Left" "-20 0")
    ];

    bindm = [
      "SUPER, mouse:273, resizewindow"
      "SUPER, mouse:272, movewindow"
    ];

    bindir = [
      "Super, Super_L, exec, ags -t 'overview'"
    ]; 
  };
}
