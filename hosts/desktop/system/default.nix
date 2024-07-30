{
  imports = [ 
    ./boot.nix
    ./hardware-configuration.nix
    ./locale.nix
  ]; 

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];
  
  services.xserver.videoDrivers = [ "amdgpu" ];
}