{ compiler ? "ghc902"
, ...
}:

let
  ## Import sources:
  sources = import ./nix/sources.nix;

  ## Pinned nixpkgs:
  pkgs = import sources.nixpkgs { };

  ## Get the haskell set with overrides:
  haskell = pkgs.haskell.packages.${compiler};

  ## Get this Haskell package:
  thisPackage = haskell.callCabal2nixWithOptions "haskell-static-compilation-example" ./. "--no-haddock" { };

  ## Get this Haskell package's dependencies:
  thisPackageDeps = pkgs.haskell.lib.compose.getHaskellBuildInputs thisPackage;

  ## Get our GHC for development:
  ghc = haskell.ghcWithPackages (_: thisPackageDeps);
in
pkgs.mkShell {
  buildInputs = [
    ## Fancy stuff:
    pkgs.figlet
    pkgs.lolcat

    ## Release stuff:
    pkgs.busybox
    pkgs.gh
    pkgs.git
    pkgs.git-chglog
    pkgs.upx

    ## Haskell stuff:
    ghc
    pkgs.cabal-install
    pkgs.cabal2nix
    pkgs.haskell-language-server
    pkgs.haskellPackages.apply-refact
    pkgs.hlint
    pkgs.stylish-haskell
  ];

  shellHook = ''
    figlet -w 999 "EXAMPLE DEV SHELL" | lolcat -S 42
  '';
}
