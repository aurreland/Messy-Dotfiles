{
  pkgs,
  userSettings,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "hera" ''
      sync-user() {
          ${pkgs.home-manager}/bin/home-manager switch --flake ${userSettings.dotfiles} #user;
          sync-posthook
      }

      sync-system() {
          sudo nixos-rebuild switch --flake ${userSettings.dotfiles} #system;
      }

      sync-posthook() {
          pgrep Hyprland &>/dev/null && echo "Reloading hyprland" && ${pkgs.hyprland}/bin/hyprctl reload &>/dev/null
          pkill ags
          pkill ydotool
          ${pkgs.ags}/bin/ags
          kill -10 $(pgrep kitty)
      }

      update() {
          sudo nix flake update ${userSettings.dotfiles}
      }

      upgrade() {
          update
          sync-user
          sync-system
      }

      pull() {
          soften
          pushd ${userSettings.dotfiles} &>/dev/null
          ${pkgs.git}/bin/git stash
          ${pkgs.git}/bin/git pull
          ${pkgs.git}/bin/git stash apply
          popd &>/dev/null
          harden
      }

      harden() {
          pushd ${userSettings.dotfiles} &>/dev/null
          sudo chown 0:0 .
          sudo chown -R 0:0 hosts
          sudo chown -R 0:0 nixos
          sudo chown -R 1000:users home-manager
          sudo chown -R 1000:users hosts/desktop/home
          sudo chown 1000:users **/README.md
          popd &>/dev/null
      }

      soften() {
          pushd ${userSettings.dotfiles} &>/dev/null
          sudo chown -R 1000:users .
          popd &>/dev/null
      }

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
          -h | --harden)
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
