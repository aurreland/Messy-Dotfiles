{ pkgs, username, ... }: {

  imports = [
    ./audio.nix
    ./boot.nix
    ./hardware-configuration.nix
    ./hyprland.nix
    ./kanata.nix
    ./locale.nix
    ./system.nix
  ];

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    extraGroups = [
      "nixosvmtest"
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "libvirtd"
    ];
  };

  system.stateVersion = "23.05";
}
