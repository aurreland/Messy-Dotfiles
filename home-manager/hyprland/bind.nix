{
  inputs,
  pkgs,
  config,
  ...
}: let
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  grim = "${pkgs.grim}/bin/grim";
  grimblast = "${pkgs.grimblast}/bin/grimblast";
  slurp = "${pkgs.slurp}/bin/slurp";
  swappy = "${pkgs.swappy}/bin/swappy";
  tesseract = "${pkgs.tesseract}/bin/tesseract";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";

  record_script = pkgs.writeShellScriptBin "record_script" ''
    getdate() {
        date '+%Y-%m-%d_%H.%M.%S'
    }
    getaudiooutput() {
        ${pkgs.pulseaudio}/bin/pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2
    }
    getactivemonitor() {
        ${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[] | select(.focused == true) | .name'
    }

    mkdir -p ${config.xdg.userDirs.videos}
    cd ${config.xdg.userDirs.videos} || exit
    if pgrep ${pkgs.wf-recorder}/bin/wf-recorder > /dev/null; then
        ${pkgs.libnotify}/bin/notify-send "Recording Stopped" "Stopped" -a 'record_nosound' &
        pkill ${pkgs.wf-recorder}/bin/wf-recorder &
    else
        ${pkgs.libnotify}/bin/notify-send "Starting recording" 'recording_'"$(getdate)"'.mp4' -a 'record_nosound'
        if [[ "$1" == "--sound" ]]; then
            ${pkgs.wf-recorder}/bin/wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$(${pkgs.slurp}/bin/slurp)" --audio="$(getaudiooutput)" & disown
        elif [[ "$1" == "--fullscreen-sound" ]]; then
            ${pkgs.wf-recorder}/bin/wf-recorder -o $(getactivemonitor) --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --audio="$(getaudiooutput)" & disown
        elif [[ "$1" == "--fullscreen" ]]; then
            ${pkgs.wf-recorder}/bin/wf-recorder -o $(getactivemonitor) --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t & disown
        else
            ${pkgs.wf-recorder}/bin/wf-recorder --pixel-format yuv420p -f './recording_'"$(getdate)"'.mp4' -t --geometry "$(${pkgs.slurp}/bin/slurp)" & disown
        fi
    fi
  '';

  workspace_action = pkgs.writeShellScriptBin "workspace_action" ''
    ${pkgs.hyprland}/bin/hyprctl dispatch "$1" $(((($(${pkgs.hyprland}/bin/hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r .id) - 1)  / 10) * 10 + $2))
  '';
in {
  home.packages = [workspace_action record_script];

  xdg.configFile."hypr/binds.conf".text = let
    workspaces = mod: cmd: key: arg: "bind = ${mod}, ${key}, exec, workspace_action ${cmd} ${arg} # [hidden]";
    ws = workspaces "Super" "workspace";
    mvws = workspaces "Super+Shift" "movetoworkspace";
    mvwssl = workspaces "Super+Alt" "movetoworkspacesilent";
    arr = ["ampersand" "eacute" "quotedbl" "apostrophe" "parenleft" "minus" "egrave" "underscore" "ccedilla" "agrave"];
  in ''
    bindl = Alt ,XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_SOURCE@ toggle # [hidden]
    bindl = Super ,XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_SOURCE@ toggle # [hidden]
    bindl = ,XF86AudioMute, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0% # [hidden]
    bindl = Super+Shift,M, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 0% # [hidden]
    bindle=, XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ # [hidden]
    bindle=, XF86AudioLowerVolume, exec, ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%- # [hidden]

    #!
    ##! Actions
    # Screenshot, Record, OCR, Color picker, Clipboard history
    bind = Super+Shift, S, exec, ${grimblast} --freeze copy area # Screen snip
    bind = Super+Shift+Alt, S, exec, ${grim} -g "$(${slurp})" - | ${swappy} -f - # Screen snip >> edit
    # OCR
    bind = Super+Shift, T, exec, ${grim} -g "$(${slurp} $SLURP_ARGS)" "tmp.png" && ${tesseract} "tmp.png" - | ${wl-copy} && rm "tmp.png" # Screen snip to text >> clipboard
    # Color picker
    bind = Super+Shift, C, exec, ${hyprpicker} -a # Pick color (Hex) >> clipboard
    # Fullscreen screenshot
    bindl=,Print,exec,${grim} - | ${wl-copy} # Screenshot >> clipboard
    bindl= Ctrl,Print, exec, mkdir -p ${config.xdg.userDirs.pictures}/Screenshots && ${grimblast} copysave screen ${config.xdg.userDirs.pictures}/Screenshots/Screenshot_"$(date '+%Y-%m-%d_%H.%M.%S')".png # Screenshot >> clipboard & file
    # Recording stuff
    bind = Super+Alt, R, exec, record_script # Record region (no sound)
    bind = Ctrl+Alt, R, exec, record_script --fullscreen # [hidden] Record screen (no sound)
    bind = Super+Shift+Alt, R, exec, record_script --fullscreen-sound # Record screen (with sound)

    ##! Session
    bind = Ctrl+Super, L, exec, ags run-js 'lock.lock()' # [hidden]
    bind = Super, L, exec, loginctl lock-session # Lock
    bind = Super+Shift, L, exec, loginctl lock-session # [hidden]
    bindl = Super+Shift, L, exec, sleep 0.1 && systemctl suspend || loginctl suspend # Suspend system
    bind = Ctrl+Shift+Alt+Super, Delete, exec, systemctl poweroff || loginctl poweroff # [hidden] Power off

    #!
    ##! Window management
    # Focusing
    #/# bind = Super, ←/↑/→/↓,, # Move focus in direction
    bind = Super, Left, movefocus, l # [hidden]
    bind = Super, Right, movefocus, r # [hidden]
    bind = Super, Up, movefocus, u # [hidden]
    bind = Super, Down, movefocus, d # [hidden]
    #bind = Super, dead_circumflex, movefocus, l # [hidden]
    #bind = Super, dollar, movefocus, r # [hidden]
    bindm = Super, mouse:272, movewindow
    bindm = Super, mouse:273, resizewindow
    bind = Alt, A, killactive,
    bind = Control+Alt, A, exec, ${hyprctl} kill # Pick and kill a window
    ##! Window arrangement
    #/# bind = Super+Shift, ←/↑/→/↓,, # Window: move in direction
    bind = Super+Shift, Left, movewindow, l # [hidden]
    bind = Super+Shift, Right, movewindow, r # [hidden]
    bind = Super+Shift, Up, movewindow, u # [hidden]
    bind = Super+Shift, Down, movewindow, d # [hidden]
    # Window split ratio
    #/# binde = Super, +/-,, # Window: split ratio +/- 0.1
    binde = Super, Minus, splitratio, -0.1 # [hidden]
    binde = Super, Equal, splitratio, +0.1 # [hidden]
    #binde = Super, Semicolon, splitratio, -0.1 # [hidden]
    #binde = Super, Apostrophe, splitratio, +0.1 # [hidden]
    # Positioning mode
    bind = Super+Alt, Space, togglefloating,
    bind = Super+Alt, F, fakefullscreen,
    bind = Super, F, fullscreen, 0
    bind = Super, D, fullscreen, 1

    #!
    ##! Workspace navigation
    # Switching
    #/# bind = Super, Hash,, # Focus workspace # (1, 2, 3, 4, ...)
    ${builtins.concatStringsSep "\n" (map (i: ws (builtins.elemAt arr i) (toString (i + 1))) (builtins.genList (i: i) (builtins.length arr)))}


    #/# bind = Ctrl+Super, ←/→,, # Workspace: focus left/right
    bind = Ctrl+Super, Right, workspace, +1 # [hidden]
    bind = Ctrl+Super, Left, workspace, -1 # [hidden]
    #/# bind = Super, Scroll ↑/↓,, # Workspace: focus left/right
    bind = Super, mouse_up, workspace, +1 # [hidden]
    bind = Super, mouse_down, workspace, -1 # [hidden]
    bind = Ctrl+Super, mouse_up, workspace, +1 # [hidden]
    bind = Ctrl+Super, mouse_down, workspace, -1 # [hidden]
    #/# bind = Super, Page_↑/↓,, # Workspace: focus left/right
    bind = Super, Page_Down, workspace, +1 # [hidden]
    bind = Super, Page_Up, workspace, -1 # [hidden]
    bind = Ctrl+Super, Page_Down, workspace, +1 # [hidden]
    bind = Ctrl+Super, Page_Up, workspace, -1 # [hidden]
    ## Special
    bind = Super, S, togglespecialworkspace,
    bind = Super, mouse:275, togglespecialworkspace,


    ##! Workspace management
    # Move window to workspace Super + Shift + [0-9]
    #/# bind = Super+Shift, Hash,, # Window: move to workspace # (1, 2, 3, 4, ...)
    ${builtins.concatStringsSep "\n" (map (i: mvws (builtins.elemAt arr i) (toString (i + 1))) (builtins.genList (i: i) (builtins.length arr)))}
    # Move window to workspace silently Super + Alt + [0-9]
    #/# bind = Super+Alt, Hash,, # Window: move to workspace silently # (1, 2, 3, 4, ...)
    ${builtins.concatStringsSep "\n" (map (i: mvwssl (builtins.elemAt arr i) (toString (i + 1))) (builtins.genList (i: i) (builtins.length arr)))}

    bind = Ctrl+Super+Shift, Right, movetoworkspace, +1 # [hidden]
    bind = Ctrl+Super+Shift, Left, movetoworkspace, -1 # [hidden]
    bind = Ctrl+Super, dead_circumflex, workspace, -1 # [hidden]
    bind = Ctrl+Super, dollatkr, workspace, +1 # [hidden]
    bind = Ctrl+Super, Up, workspace, -5 # [hidden]
    bind = Ctrl+Super, Down, workspace, +5 # [hidden]
    #/# bind = Super+Shift, Scroll ↑/↓,, # Window: move to workspace left/right
    bind = Super+Shift, mouse_down, movetoworkspace, -1 # [hidden]
    bind = Super+Shift, mouse_up, movetoworkspace, +1 # [hidden]
    bind = Super+Alt, mouse_down, movetoworkspace, -1 # [hidden]
    bind = Super+Alt, mouse_up, movetoworkspace, +1 # [hidden]
    #/# bind = Super+Shift, Page_↑/↓,, # Window: move to workspace left/right
    bind = Super+Alt, Page_Down, movetoworkspace, +1 # [hidden]
    bind = Super+Alt, Page_Up, movetoworkspace, -1 # [hidden]
    bind = Super+Shift, Page_Down, movetoworkspace, +1  # [hidden]
    bind = Super+Shift, Page_Up, movetoworkspace, -1  # [hidden]
    bind = Super+Alt, S, movetoworkspacesilent, special
    bind = Super, P, pin

    bind = Ctrl+Super, S, togglespecialworkspace, # [hidden]
    bind = Alt, Tab, cyclenext # [hidden] sus keybind
    bind = Alt, Tab, bringactivetotop, # [hidden] bring it to the top

    #!
    ##! Widgets
    bind = Ctrl+Super, T, exec, ~/.config/ags/scripts/color_generation/switchwall.sh # Change wallpaper
    bindr = Ctrl+Super, R, exec, pkill ags; pkill ydotool; ags & # Restart widgets
    bindr = Ctrl+Super+Alt, R, exec, ${hyprctl} reload; killall ags ydotool; ags & # [hidden]
    bind = Ctrl+Alt, exclam, exec, ags run-js 'cycleMode();' # Cycle bar mode (normal, focus)
    bindir = Super, Super_L, exec, ags -t 'overview' # [hidden] Toggle overview/launcher
    bind = Super, Tab, exec, ags -t 'overview' # [hidden]
    bind = Super, exclam, exec, for ((i=0; i<$(${hyprctl} monitors -j | jq length); i++)); do ags -t "cheatsheet""$i"; done # Show cheatsheet
    bind = Super, B, exec, ags -t 'sideleft' # Toggle left sidebar
    bind = Super, N, exec, ags -t 'sideright' # Toggle right sidebar
    bind = Super, M, exec, ags run-js 'openMusicControls.value = (!mpris.getPlayer() ? false : !openMusicControls.value);' # Toggle music controls
    bind = Super, Comma, exec, ags run-js 'openColorScheme.value = true; Utils.timeout(2000, () => openColorScheme.value = false);' # View color scheme and options
    bind = Super, K, exec, for ((i=0; i<$(${hyprctl} monitors -j | jq length); i++)); do ags -t "osk""$i"; done # Toggle on-screen keyboard
    bind = Ctrl+Alt, Delete, exec, for ((i=0; i<$(${hyprctl} monitors -j | jq length); i++)); do ags -t "session""$i"; done # Toggle power menu
    bind = Ctrl+Super, G, exec, for ((i=0; i<$(${hyprctl} monitors -j | jq length); i++)); do ags -t "crosshair""$i"; done # Toggle crosshair
    bindle=, XF86MonBrightnessUp, exec, ags run-js 'brightness.screen_value += 0.05; indicator.popup(1);' # [hidden]
    bindle=, XF86MonBrightnessDown, exec, ags run-js 'brightness.screen_value -= 0.05; indicator.popup(1);' # [hidden]
    bindl  = , XF86AudioMute, exec, ags run-js 'indicator.popup(1);' # [hidden]
    bindl  = Super+Shift,M,   exec, ags run-js 'indicator.popup(1);' # [hidden]

    # Testing
    # bind = SuperAlt, f12, exec, ${notify-send} "Hyprland version: $(${hyprctl} version | head -2 | tail -1 | cut -f2 -d ' ')" "owo" -a 'Hyprland keybind'
    # bind = Super+Alt, f12, exec, ${notify-send} "Millis since epoch" "$(date +%s%N | cut -b1-13)" -a 'Hyprland keybind'
    bind = Super+Alt, f12, exec, ${notify-send} 'Test notification' "Here's a really long message to test truncation and wrapping\nYou can middle click or flick this notification to dismiss it!" -a 'Shell' -A "Test1=I got it!" -A "Test2=Another action" -t 5000 # [hidden]
    bind = Super+Alt, Equal, exec, ${notify-send} "Urgent notification" "Ah hell no" -u critical -a 'Hyprland keybind' # [hidden]

    ##! Media
    bindl= Super+Shift, N, exec, ${playerctl} next || ${playerctl} position `bc <<< "100 * $(${playerctl} metadata mpris:length) / 1000000 / 100"` # Next track
    bindl= ,XF86AudioNext, exec, ${playerctl} next || ${playerctl} position `bc <<< "100 * $(${playerctl} metadata mpris:length) / 1000000 / 100"` # [hidden]
    bind = Super+Shift+Alt, mouse:275, exec, ${playerctl} previous # [hidden]
    bind = Super+Shift+Alt, mouse:276, exec, ${playerctl} next || ${playerctl} position `bc <<< "100 * $(${playerctl} metadata mpris:length) / 1000000 / 100"` # [hidden]
    bindl= Super+Shift, B, exec, ${playerctl} previous # Previous track
    bindl= Super+Shift, P, exec, ${playerctl} play-pause # Play/pause media
    bindl= ,XF86AudioPlay, exec, ${playerctl} play-pause # [hidden]

    #!
    ##! Apps
    bind = , Super, exec, true # Open app launcher
    bind = Super, Q, exec, ${pkgs.kitty}/bin/kitty # Launch kitty (terminal)
    bind = Super, C, exec, ${pkgs.vscode}/bin/code --password-store=gnome --enable-features=UseOzonePlatform --ozone-platform=wayland # Launch VSCode (editor)
    bind = Super, E, exec, ${pkgs.nautilus}/bin/nautilus -w # Launch Nautilus (file manager)
    bind = Super, W, exec, ${pkgs.google-chrome}/bin/google-chrome-stable # Launch Google Chrome (browser)
    bind = Super, I, exec, XDG_CURRENT_DESKTOP="gnome" ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center # Launch GNOME Settings
    bind = Ctrl+Super, V, exec, ${pkgs.pavucontrol}/bin/pavucontrol # Launch pavucontrol (volume mixer)
    bind = Ctrl+Super+Shift, V, exec, ${pkgs.easyeffects}/bin/easyeffects # Launch EasyEffects (equalizer & other audio effects)
    bind = Ctrl+Shift, Escape, exec, ${pkgs.mission-center}/bin/mission-center # Launch System monitor
    bind = Ctrl+Super, exclam, exec, pkill ${pkgs.anyrun}/bin/anyrun || ${pkgs.anyrun}/bin/anyrun # Toggle fallback launcher: anyrun

    ##! Scratchpads
    bind = Super+Ctrl, Q, exec, pypr toggle term # Toggles a Terminal Scratchpads
    bind = Super+Ctrl, S, exec, pypr toggle secrets # Toggles Password Manager

    # Cursed stuff
    ## Make window not amogus large
    bind = Super+Alt+Shift, exclam, resizeactive, exact 640 480 # [hidden]
  '';

  wayland.windowManager.hyprland.settings.source = ["${config.home.homeDirectory}/.config/hypr/binds.conf"];
}
