{
  system,
  inputs,
  ...
}: let
  spicePkgs = inputs.spicetify-nix.packages.${system}.default;
in {
  imports = [inputs.spicetify-nix.homeManagerModule];

  programs.spicetify = {
    #enable = true;
    #enabledCustomApps = with spicePkgs.apps; [
    #  marketplace
    #];
  };
}
