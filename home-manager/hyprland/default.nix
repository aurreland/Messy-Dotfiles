{ inputs, pkgs, config, ... }:
let
  hyprland = inputs.hyprland.packages.${pkgs.system}.hyprland;
in {

  imports = [
    ./plugins
    ./bind.nix
    ./windowrules.nix
  ];

  home.packages = with pkgs; [
    swww
    nwg-displays
    kitty
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland;
    systemd.enable = true;
    xwayland.enable = true;

    settings = {
      source = let
        home_folder = config.home.homeDirectory;
      in [
        "${home_folder}/.config/hypr/colors.conf"
        "${home_folder}/.config/hypr/monitors.conf"
      ];

      exec-once = [
        "hyprctl setcursor ${config.home.pointerCursor.name} ${(toString config.home.pointerCursor.size)}"
        "swww-daemon"
        "pypr"
        "ags &"
      ];

      input = {
        kb_layout = "fr,us";
        kb_options = "grp:win_space_toggle";
        numlock_by_default = true;

        repeat_delay = 250;
        repeat_rate = 35;

        special_fallthrough	= true;
        follow_mouse = 1;
      };

      binds = {
        scroll_event_delay = 0;
      };

      general = {
        border_size = 1;
        
        gaps_in = 4;
        gaps_out = 5;
        gaps_workspaces = 50;

        no_border_on_floating = true;
        no_focus_fallback = true;
        layout = "dwindle";

        resize_on_border = true;
        allow_tearing = true;
      };

      dwindle = {
        preserve_split = true;
        smart_split = false;
        smart_resizing = false;
      };

      decoration = {
        rounding = 20;

        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_range = 20;
        shadow_render_power = 4;
        shadow_offset = "0 2";
        "col.shadow" = "rgba(0000002A)";

        dim_inactive = false;
        dim_strength = 0.1;
        dim_special = 0;

        blur = {
          enabled = true;
          xray = true;
          special = false;
          new_optimizations = true;
          size = 14;
          passes = 4;
          noise = 0.01;
          contrast = 1;
          brightness = 1;
          popups = true;
          popups_ignorealpha = 0.6;
        };
      };

      misc = {
        vfr = 1;
        vrr = 1;
        layers_hog_keyboard_focus = true;
        focus_on_activate = true;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        enable_swallow = false;
        swallow_regex = "(foot|kitty|allacritty|Alacritty)";
        
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        new_window_takes_over_fullscreen = 2;
        allow_session_lock_restore = true;
        
        initial_workspace_tracking = false;
      };

      animations = {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92 "
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
        ];
        animation = [
          "windows, 1, 3, md3_decel, popin 60%"
          "windowsIn, 1, 3, md3_decel, popin 60%"
          "windowsOut, 1, 3, md3_accel, popin 60%"
          "border, 1, 10, default"
          "fade, 1, 3, md3_decel"
          "layers, 1, 2, md3_decel, slide"
          "layersIn, 1, 3, md3_decel, slide"
          "layersOut, 1, 1.6, menu_accel"
          "fadeLayersIn, 1, 2, menu_decel"
          "fadeLayersOut, 1, 4.5, menu_accel"
          "workspaces, 1, 7, menu_decel"
          "specialWorkspace, 1, 3, md3_decel, slidevert"
        ];
      };
    };
  };
}
