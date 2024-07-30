{
  host,
  userSettings,
  ...
}: {
  imports = [
    (../hosts + ("/" + host) + "/system")
    ./audio.nix
    ./hyprland.nix
    ./kanata.nix
    ./system.nix
  ];

  users.users.${userSettings.username} = {
    isNormalUser = true;
    initialPassword = userSettings.username;
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
