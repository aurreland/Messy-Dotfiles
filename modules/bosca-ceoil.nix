{
  lib,
  stdenv,
  alsa-lib,
  autoPatchelfHook,
  fetchFromGitHub,
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
}:
stdenv.mkDerivation rec {
  pname = "boscaceoil-blue";
  version = "3.0-stable";

  src = fetchFromGitHub {
    owner = "YuriSizov";
    repo = "boscaceoil-blue";
    rev = version;
    sha256 = "sha256-4WabZAWahJwTd2wCTeWvKq/EiNjjMd+X2uCcXXLibJw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    godot3-headless
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
    godot3-headless -v --export "Linux/X11" ./build/boscaceoil-blue

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/boscaceoil-blue
    install -d -m 755 $out/bin
    ln -s $out/libexec/boscaceoil-blue $out/bin/boscaceoil-blue

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
