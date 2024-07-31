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
  udev, # for libudev
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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/material-maker
    install -D -m 644 -t $out/libexec ./build/material-maker.pck

    ls $src/material_maker
    pwd $src/material_maker

    cp -r $src/material_maker/doc $out/libexec
    chmod -R 755 $out/libexec/doc
    cp -r $src/material_maker/environments $out/libexec
    chmod -R 755 $out/libexec/environments
    cp -r $src/material_maker/examples $out/libexec
    chmod -R 755 $out/libexec/examples
    cp -r $src/material_maker/misc/export $out/libexec
    chmod -R 755 $out/libexec/export
    cp -r $src/material_maker/library $out/libexec
    chmod -R 755 $out/libexec/library
    cp -r $src/material_maker/meshes $out/libexec
    chmod -R 755 $out/libexec/meshes
    cp -r $src/material_maker/nodes $out/libexec
    chmod -R 755 $out/libexec/nodes

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
    homepage = "https://www.materialmaker.org/";
    description = "";
    license = with licenses; [blueOak100];
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [jojosch];
  };
}
