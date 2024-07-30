{
  config,
  userSettings,
  ...
}: let
  homeDirectory = "/home/${userSettings.username}";
in {
  gtk.gtk3.bookmarks = [
    "file://${config.xdg.userDirs.documents} Documents"
    "file://${config.xdg.userDirs.download} Downloads"
    "file://${config.xdg.userDirs.pictures} Pictures"
    "file://${config.xdg.userDirs.music} Music"
    "file://${homeDirectory}/Media Media"
    "file://${homeDirectory}/.config Config"
    "file://${homeDirectory}/.local/share Local"
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      music = "${config.home.homeDirectory}/Media/Music";
      videos = "${config.home.homeDirectory}/Media/Videos";
      pictures = "${config.home.homeDirectory}/Media/Pictures";
      templates = null;
      download = "${config.home.homeDirectory}/Media/Downloads";
      documents = "${config.home.homeDirectory}/Media/Documents";
      desktop = "Desktop";
      publicShare = null;
    };
  };
}
