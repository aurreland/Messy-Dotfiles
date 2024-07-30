{pkgs, ...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "loginctl lock-session";
      };
      listener = {
        timeout = 60 * 3;
        on-timeout = "loginctl lock-session";
      };
      listener = {
        timeout = 60 * 5;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      };
      listener = {
        timeout = 60 * 10;
        on-timeout = "pidof steam || systemctl suspend || loginctl suspend";
      };
    };
  };
}
