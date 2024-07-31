{
  pkgs,
  userSettings,
  ...
}: let
  helpMessage =
    ''
      --s|--sync:
        - Usage: -s | --sync [user|system|null]
        - Description: Sync configurations for either the user or system or both if no args provided.

      --r|--refresh:
        - Usage: -r | --refresh
        - Description: Refresh/Reload the system

      --u|--update:
        - Usage: -u | --update
        - Description: Update the system configurations.

      --U|--upgrade:
        - Usage: -U | --upgrade
        - Description: Upgrade the system by updating and syncing user/system configurations.

      --p|--pull:
        - Usage: -p | --pull
        - Description: Pull changes from the remote repository, updating local configurations.

      --h|--harden:
        - Usage: -h | --harden
        - Description: Set strict permissions on configuration files.

      --S|--soften:
        - Usage: -S | --soften
        - Description: Set relaxed permissions on configuration files.

      --g|--garbage:
        - Usage: -g | --garbage [full|<time>|null(30d)]
        - Description: Clear system garbage files based on options provided.

      --h|--help:
        - Usage: -h | --help
        - Description: Display help menu with available options.
    ''
    + "\n";
in {
  home.packages = [
    (pkgs.writeShellScriptBin "hera" ''
      sync-user() {
          ${pkgs.home-manager}/bin/home-manager switch --flake ${userSettings.dotfilesDir}/#user;
          sync-posthook
      }

      sync-system() {
          sudo nixos-rebuild switch --flake ${userSettings.dotfilesDir}/#system;
      }

      sync-posthook() {
          pgrep Hyprland &>/dev/null && echo "Reloading hyprland" && ${pkgs.hyprland}/bin/hyprctl reload &>/dev/null
          pkill ags
          pkill ydotool
          ${pkgs.ags}/bin/ags
          kill -10 $(pgrep kitty)
      }

      update() {
          sudo nix flake update ${userSettings.dotfilesDir}/
      }

      upgrade() {
          update
          sync-user
          sync-system
      }

      pull() {
          soften
          pushd ${userSettings.dotfilesDir} &>/dev/null
          ${pkgs.git}/bin/git stash
          ${pkgs.git}/bin/git pull
          ${pkgs.git}/bin/git stash apply
          popd &>/dev/null
          harden
      }

      harden() {
          pushd ${userSettings.dotfilesDir} &>/dev/null
          sudo chown 0:0 ${userSettings.dotfilesDir}
          sudo chown -R 0:0 ${userSettings.dotfilesDir}/hosts
          sudo chown -R 0:0 ${userSettings.dotfilesDir}/nixos
          sudo chown -R 1000:users ${userSettings.dotfilesDir}/home-manager
          sudo chown -R 1000:users ${userSettings.dotfilesDir}/hosts/desktop/home
          sudo chown 1000:users ${userSettings.dotfilesDir}/**/README.md
          popd &>/dev/null
      }

      soften() {
          pushd ${userSettings.dotfilesDir} &>/dev/null
          sudo chown -R 1000:users ${userSettings.dotfilesDir}
          popd &>/dev/null
      }

      help() {
          echo "${helpMessage}"
      }

      if [ $# -eq 0 ]; then
          help
          exit 0
      fi

      while [[ $# -gt 0 ]]; do
          case "$1" in
          -s | --sync)
              if [ "$2" == "user" ]; then
                  sync-user
              elif [ "$2" == "system" ]; then
                  sync-system
              else
                  sync-user
                  sync-system
              fi
              shift 2
              ;;
          -r | --refresh)
              sync-posthook
              shift 1
              ;;
          -u | --update)
              update
              shift 1
              ;;
          -U | --upgrade)
              upgrade
              shift 1
              ;;
          -p | --pull)
              pull
              shift 1
              ;;
          -H | --harden)
              harden
              shift 1
              ;;
          -S | --soften)
              soften
              shift 1
              ;;
          -g | --garbage)
              if [ "$2" == "full" ]; then
                  sudo nix-collect-garbage --delete-old
                  nix-collect-garbage --delete-old
              elif [ "$2" ]; then
                  sudo nix-collect-garbage --delete-older-than $2
                  nix-collect-garbage --delete-older-than $2
              else
                  sudo nix-collect-garbage --delete-older-than 30d
                  nix-collect-garbage --delete-older-than 30d
              fi
              ;;
          -h | --help)
              help
              shift 1
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
