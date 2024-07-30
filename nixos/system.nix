{
  pkgs,
  inputs,
  systemSettings,
  ...
}: {
  # nix
  documentation.nixos.enable = false; # .desktop
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # ags
  boot.kernelModules = ["i2c-dev"];

  # dconf
  programs.dconf.enable = true;

  # packages
  environment.systemPackages = with pkgs;
  with gnome; [
    home-manager
    neovim
    git
    wget
    sbctl
    flatpak
    gnome-software
    inputs.alejandra.defaultPackage.${systemSettings.system}
  ];

  # services
  services = {
    xserver = {
      enable = true;
      excludePackages = [pkgs.xterm];
    };
    printing.enable = true;
    flatpak.enable = true;
  };

  # logind
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleLidSwitch=suspend
    HandleLidSwitchExternalPower=ignore
  '';

  # kde connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # network
  networking = {
    hostName = systemSettings.hostname;
    networkmanager.enable = true;
  };

  system.stateVersion = "23.05";
}
