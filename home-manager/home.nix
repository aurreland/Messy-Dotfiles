{
  pkgs,
  host,
  username,
  ...
}: let
  homeDirectory = "/home/${username}";
in {
  imports = [
    (../hosts + ("/" + host) + "/home")
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
      experimental-features = ["nix-command" "flakes"];
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
      GOMODCACHE = "${homeDirectory}/.cache/go/pkg/mod";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
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
