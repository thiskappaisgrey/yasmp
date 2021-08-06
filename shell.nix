{ sources ? import ./nix/sources.nix {},
  pkgs ? import sources.nixpkgs {}}:
let
  inherit  pkgs;
  inherit (pkgs) haskellPackages;

  project = import ./release.nix;
in
pkgs.stdenv.mkDerivation {
  name = "shell";
  buildInputs = project.env.nativeBuildInputs ++ [
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server
  ];
}
