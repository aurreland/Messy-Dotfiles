{
  programs.kitty = {
    enable = true;
    settings = {
        include = "colors.conf";
        shell = "nu";
        confirm_os_window_close = 0;
        window_padding_width = 20;
        allow_remote_control = true;
    };
  };
}
