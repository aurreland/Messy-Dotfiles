{
  services.kanata = {
    enable = true;
    keyboards = {
      main = {
        devices = ["/dev/input/by-id/usb-Logitech_USB_Keyboard-event-kbd"];
        extraDefCfg = "process-unmapped-keys yes";
        config = ''
          (defsrc
            caps)

          (defalias
            escctrl (tap-hold 100 100 esc lctrl))

          (deflayer base
            @escctrl)
        '';
      };
    };
  };
}
