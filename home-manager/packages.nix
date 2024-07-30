{ pkgs, pkgs-stable, ...}: {
  
  imports = [
    ./scripts/blocks.nix
  ];

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=gnome ${pkgs.gnome.gnome-control-center}/bin/gnome-control-center";
    categories = ["X-Preferences"];
    terminal = false;
  };

  home.packages = (with pkgs; [
      mission-center # Processes Monitor
      spotify # Spotify
      google-chrome # Chrome
      vscode # VS Code
      fragments # Torrents
      vesktop # Discord
      valuta # Convert currencies
      switcheroo # Convert Images
      paper-clip # Edit PDF document metadata
      newsflash # RSS Reader
      lorem # Generate placeholder text
      gnome-graphs # Manipulate Data
      raider # Permanently delete your files
      errands # Manage Tasks
      dialect # Translate between languages
      gnome-decoder # Scan and Generate QR Codes
      decibels # Play audio files
      apostrophe # Markdown Editor
      blanket # Ambient Sounds
      github-desktop # Github

      # rust
      cargo
      cargo-generate
      rustc

      # cli
      nixfmt
      bat
      eza
      fd
      ripgrep
      fzf
      lazydocker
      jq
    ]) ++ (with pkgs-stable; [
      gnome-secrets # Keepass Manager
      # gaphor # Simple modelling tool
    ]);
}
