{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  fetchurl,
  godot3-headless,
  godot3-export-templates,
  libGLU,
  libpulseaudio,
  libX11,
  libXcursor,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  nix-update-script,
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

  nativeBuildInputs = [
    autoPatchelfHook
    godot3-headless
    unzip
  ];

  buildInputs = [
    libGLU
    libX11
    libXcursor
    libXi
    libXinerama
    libXrandr
    libXrender
  ];

  buildPhase = ''
    runHook preBuild

    # Cannot create file '/homeless-shelter/.config/godot/projects/...'
    export HOME=$TMPDIR

    # Link the export-templates to the expected location. The --export commands
    # expects the template-file at .../templates/3.2.3.stable/linux_x11_64_release
    # with 3.2.3 being the version of godot.
    mkdir -p $HOME/.local/share/godot
    ln -s ${godot3-export-templates}/share/godot/templates $HOME/.local/share/godot

    mkdir -p build
    unzip $src -d build
    ls build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/boscaceoil-blue-linux-x86_64
    install -d -m 755 $out/bin
    ln -s $out/libexec/boscaceoil-blue-linux-x86_64 $out/bin/boscaceoil-blue

    runHook postInstall
  '';

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ];

  meta = with lib; {
    homepage = "https://ohmygit.org/";
    description = "An interactive Git learning game";
    license = with licenses; [blueOak100];
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [jojosch];
  };
}
