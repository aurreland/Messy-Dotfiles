{
  system,
  inputs,
  ...
}: {
  #home.packages = [ inputs.spicetify-nix.packages.${system}.default ];

  #imports = [ inputs.spicetify-nix.homeManagerModule ];
}
