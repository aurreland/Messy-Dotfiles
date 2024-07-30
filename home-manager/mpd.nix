{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.mpc-cli pkgs.ncmpcpp];

  services.mpd = {
    enable = true;
    dataDir = "${config.home.homeDirectory}/.config/mpd";
    extraConfig = ''
      db_file "${config.home.homeDirectory}/.config/mpd/database"

      music_directory    "${config.xdg.userDirs.music}"

      auto_update "yes"

      playlist_directory "${config.home.homeDirectory}/.config/playlists"
      pid_file           "${config.home.homeDirectory}/.config/mpd/pid"
      state_file         "${config.home.homeDirectory}/.config/mpd/state"
      sticker_file       "${config.home.homeDirectory}/.config/mpd/sticker.sql"

      audio_output {
      type "pipewire"
      name "My PipeWire Output"
      }
    '';
  };

  xdg.configFile."mpd/mpd.conf" = {
    enable = true;
    text = ''
      db_file "${config.home.homeDirectory}/.config/mpd/database"

      music_directory    "${config.xdg.userDirs.music}"

      auto_update "yes"

      playlist_directory "${config.home.homeDirectory}/.config/playlists"
      pid_file           "${config.home.homeDirectory}/.config/mpd/pid"
      state_file         "${config.home.homeDirectory}/.config/mpd/state"
      sticker_file       "${config.home.homeDirectory}/.config/mpd/sticker.sql"

      audio_output {
      type "pipewire"
      name "My PipeWire Output"
      }
    '';
  };
}
