{
  lib,
  stdenv,
  fetchzip,

  # build deps
  autoPatchelfHook,
  godot3-export-templates,
  godot3-headless,
  copyDesktopItems,
  makeDesktopItem,

  # runtime deps
  libGL,
  libGLU,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
}:
let
  version = "1.3";
  versionUnderscore = "${lib.replaceStrings [ "." ] [ "_" ] version}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "material-maker";
  inherit version;

  src =
    if stdenv.isLinux then
      fetchzip {
        url = "https://github.com/RodZill4/${finalAttrs.pname}/releases/download/${finalAttrs.version}/material_maker_${versionUnderscore}_linux.tar.gz";
        hash = "sha256-WEu5gVfnswB5zYzu3leOL+hKOBzJbn48gHQKshlfOh4=";
      }
    else
      throw "unsupported platform";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    godot3-headless
  ];

  buildInputs = [
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
  ];

  desktopItems = makeDesktopItem {
    name = "material-maker";
    exec = "material-maker";
    icon = "material-maker";
    genericName = "Procedural texture generation and 3D model painting tool";
    desktopName = "Material Maker";
    comment = finalAttrs.meta.description;
    terminal = false;
    categories = [
      "Graphics"
      "3DGraphics"
    ];
    keywords = [ "material" ];
  };

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

    install -D -m 755 $src/material_maker.x86_64 $out/libexec/material-maker
    install -D -m 644 $src/material_maker.pck $out/libexec/material-maker.pck

    for dir in examples library nodes doc environments meshes export; do
      cp -R $src/$dir $out/libexec
    done

    install -D -m 644 $src/doc/_static/icon.png -t $out/share/icons/hicolor/256x256/apps/

    mkdir -p $out/bin
    ln -s $out/libexec/material-maker $out/bin/material-maker

    runHook postInstall
  '';

  meta = {
    homepage = "https://www.materialmaker.org/";
    description = "Tool based on Godot Engine that can be used to create textures procedurally and paint 3D models";
    license = lib.licenses.mit;
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86_64;
    maintainers = with lib.maintainers; [ aurreland ];
    mainProgram = "material-maker";
  };
})
