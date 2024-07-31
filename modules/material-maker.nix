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
  pname = "material-maker";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "RodZill4";
    repo = "material-maker";
    rev = version;
    sha256 = "sha256-vyagu7xL4ITt+xyoYyCcF8qq6L9sR6Ltdl6NwfrbZdA=";
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
    godot3-headless -v --export "Linux/X11" ./build/material-maker
    godot3-headless -v --export "Linux/X11" ./build/material-maker.pck


    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/material-maker
    install -D -m 644 -t $out/libexec ./build/material-maker.pck
    install -d -m 755 $out/bin
    ln -s $out/libexec/material-maker $out/bin/material-maker

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
