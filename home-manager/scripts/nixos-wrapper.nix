{pkgs, ...}: {
  home.packages = [
    (pkgs.writeShellScriptBin "hera"
      /*
      bash
      */
      ''
        while [[ $# -gt 0 ]]; do
          case "$1" in
              -s|--sync)
                  if [ "$2" == "user" ]; then
                    sync-user()
                  elif ["$2" == "system"]; then
                    sync-system()
                  else
                     sync-user()
                     sync-system()
                  fi
                  shift 2
                  ;;
              -r|--refresh)
                  sync-posthook()
                  shift 1
                  ;;
              -u|--update)
                  update()
                  shift 1
                  ;;
              -U|--upgrade)
                  upgrade()
                  shift 1
                  ;;
              -p|--pull)
                  pull()
                  shift 1
                  ;;
              -h|--harden)
                  harden()
                  shift 1
                  ;;
              -S|--soften)
                  soften()
                  shift 1
                  ;;
              -g|--garbage)
                  if ["$2" == "full"]; then
                    sudo nix-collect-garbage --delete-old;
                    nix-collect-garbage --delete-old;
                  elif ["$2"]; then
                    sudo nix-collect-garbage --delete-older-than $2
                    nix-collect-garbage --delete-older-than $2
                  else
                    sudo nix-collect-garbage --delete-older-than 30d;
                    nix-collect-garbage --delete-older-than 30d;
                  fi
                  ;;
              *)
                  echo "Unknown option: $1"
                  shift
                  ;;
              esac
          done
      '')
  ];
}
