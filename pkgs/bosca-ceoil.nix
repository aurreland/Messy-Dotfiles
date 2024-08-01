{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  godot3-export-templates,
  godot3-headless,
  alsa-lib,
  libGL,
  libGLU,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  zlib,
  udev,
  unzip,
}:
stdenv.mkDerivation rec {
  pname = "boscaceoil-blue";
  version = "3.0-stable";

  src = fetchurl {
    url = "https://github.com/YuriSizov/boscaceoil-blue/releases/download/${version}/boscaceoil-blue-linux-x86_64.zip";
    hash = "sha256-Zkqn6TxiwUehDnyih8Vogq8VeDq28/3xTeXJhCAQQ7I=";
  };

  icon = fetchurl {
    url = "https://github.com/YuriSizov/boscaceoil-blue/raw/${version}/icon.png";
    hash = "sha256-q50UJOhT298zjywV22uKE+6rlQkH6D0q49vdFzDc2Sg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    godot3-headless
    unzip
  ];

  buildInputs = [
    alsa-lib
    libGL
    libGLU
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    zlib
    udev
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "boscaceoil-blue";
      exec = "boscaceoil-blue";
      icon = "boscaceoil-blue";
      desktopName = "Bosca Ceoil : The Blue Album";
      comment = meta.description;
      categories = ["Music"];
      keywords = ["bosca" "ceoil" "music"];
    })
  ];

  unpackPhase = ''
    mkdir -p src
    unzip $src -d src/
  '';

  buildPhase = ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/3.2.3.stable/linux_x11_64_release
    # with 3.2.3 being the version of godot.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/hicolor/256x256/apps/
    install -D -m 644 $icon -t $out/share/icons/hicolor/256x256/apps/

    install -D -m 755 ./src/boscaceoil-blue-linux-x86_64/boscaceoil-blue.x86_64 $out/bin/boscaceoil-blue

    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  meta = with lib; {
    homepage = "https://github.com/YuriSizov/boscaceoil-blue";
    description = "Simple and beginner-friendly app for making music.";
    license = licenses.mit;
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [aurreland];
    mainProgram = "boscaceoil-blue";
  };
}
