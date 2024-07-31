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

  src = fetchurl {
    url = "https://github.com/RodZill4/material-maker/releases/download/1.3/material_maker_1_3_linux.tar.gz";
    hash = "sha256-Y8+ZwXy3zqnsxqqaZeVgFSxLzmUkq+rBzbq8tEDc8/g=";
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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p src
    tar -xzvf $src -C src

    install -D -m 755 -t $out/libexec ./src/material_maker_1_3_linux/material_maker
    install -D -m 644 -t $out/libexec ./src/material_maker_1_3_linux/material_maker.pck

    cp -r ./src/material_maker_1_3_linux/doc $out/libexec
    chmod -R 755 $out/libexec/doc
    cp -r ./src/material_maker_1_3_linux/environments $out/libexec
    chmod -R 755 $out/libexec/environments
    cp -r ./src/material_maker_1_3_linux/examples $out/libexec
    chmod -R 755 $out/libexec/examples
    cp -r ./src/material_maker_1_3_linux/export $out/libexec
    chmod -R 755 $out/libexec/export
    cp -r ./src/material_maker_1_3_linux/library $out/libexec
    chmod -R 755 $out/libexec/library
    cp -r ./src/material_maker_1_3_linux/meshes $out/libexec
    chmod -R 755 $out/libexec/meshes
    cp -r ./src/material_maker_1_3_linux/nodes $out/libexec
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
