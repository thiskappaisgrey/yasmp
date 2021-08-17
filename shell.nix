{ sources ? import ./nix/sources.nix {},
  pkgs ? import sources.nixpkgs {},
  withHoogle ? true}:
let
  inherit  pkgs;
  inherit (pkgs) haskellPackages;
  f = import ./default.nix;
  packageSet = pkgs.haskellPackages;
  hspkgs = (
    if withHoogle then
      packageSet.override {
        overrides = (self: super: {
          ghc = super.ghc // { withPackages = super.ghc.withHoogle; };
          ghcWithPackages = self.ghc.withPackages;
        });
      }
      else packageSet
  );
  drv = hspkgs.callPackage f {};
in
pkgs.stdenv.mkDerivation {
  name = "shell";

  buildInputs = drv.env.nativeBuildInputs ++ [
    haskellPackages.cabal-install
    haskellPackages.haskell-language-server
    haskellPackages.ghcid
  ];
}
