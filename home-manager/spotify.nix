{
  systemSettings,
  inputs,
  ...
}: {
  imports = [inputs.spicetify-nix.homeManagerModules.default];

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${systemSettings.system};
  in {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      popupLyrics
      shuffle
      powerBar
      fullAlbumDate
      writeify
      autoVolume
      copyToClipboard
      adblock
      beautifulLyrics
    ];
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      ncsVisualizer
    ];
  };
}
