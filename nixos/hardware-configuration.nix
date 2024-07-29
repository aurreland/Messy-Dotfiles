# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4cb1f19f-596e-470c-a0e6-0111dc3af177";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/4cb1f19f-596e-470c-a0e6-0111dc3af177";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

  boot.initrd.luks.devices."luks-07e9ecd5-e5a1-420c-8c9e-3e208a49dfcf".device = "/dev/disk/by-uuid/07e9ecd5-e5a1-420c-8c9e-3e208a49dfcf";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9193-D681";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/home/aurel/Media" =
    { device = "/dev/disk/by-uuid/2106CAB6205AC3ED";
      fsType = "ntfs-3g"; 
      options = [ "rw" "uid=1000"];
    };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
