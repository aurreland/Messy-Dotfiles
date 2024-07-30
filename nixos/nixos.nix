{
  host,
  username,
  ...
}: {
  imports = [
    (../hosts + ("/" + host) + "/system")
    ./audio.nix
    ./hyprland.nix
    ./kanata.nix
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
