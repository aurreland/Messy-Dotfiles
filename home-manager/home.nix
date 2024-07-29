{ pkgs, username, config, ... }:
let
  homeDirectory = "/home/${username}";
in {

  imports = [
    ./hyprland
    ./neovim
    ./ags.nix
    #./distrobox.nix
    ./gaming.nix
    ./kitty.nix
    ./lf.nix
    ./mpd.nix
    ./packages.nix
    ./sh.nix
    ./spotify.nix
    ./starship.nix
    ./theme.nix
  ];

  news.display = "show";
  nix = {
      package = pkgs.nix;
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
  };

  home = {
    inherit username homeDirectory;

    sessionVariables = {
      QT_XCB_GL_INTEGRATION = "none"; # kde-connect
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${homeDirectory}/.local/share/go";
      GOMODCACHE="${homeDirectory}/.cache/go/pkg/mod";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  gtk.gtk3.bookmarks = [
    "file://${config.xdg.userDirs.documents} Documents"
    "file://${config.xdg.userDirs.download} Downloads"
    "file://${config.xdg.userDirs.pictures} Pictures"
    "file://${config.xdg.userDirs.music} Music"
    "file://${homeDirectory}/Media Media"
    "file://${homeDirectory}/.config Config"
    "file://${homeDirectory}/.local/share Local"
  ];

  xdg.enable = true;
  xdg.userDirs = {
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

  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;
  home.stateVersion = "21.11";
}
