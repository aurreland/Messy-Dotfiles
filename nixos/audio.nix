{ pkgs, ... }: {
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  /* sound.extraConfig = ''
    options snd-hda-intel model=auto-mute
    options snd-hda-intel auto-mute=0
  '';  */

  environment.systemPackages = [ pkgs.alsa-utils ];

}
