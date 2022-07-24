{ compiler ? "ghc902"
, doStatic ? false
, ...
}:

let
  ## Import sources:
  sources = import ./nix/sources.nix;

  ## Import nixpkgs:
  pkgs = import sources.nixpkgs { };

  ## Get the haskell set:
  haskell = pkgs.haskell.packages.${compiler};

  ## Define a function that makes this application statically compiled:
  makeAppStatic = drv: pkgs.haskell.lib.compose.overrideCabal
    (_: {
      enableSharedExecutables = false;
      enableSharedLibraries = false;
      configureFlags = [
        "--ghc-option=-optl=-static"
        "--ghc-option=-optl=-pthread"
        "--extra-lib-dirs=${pkgs.glibc.static}/lib"
        "--extra-lib-dirs=${pkgs.gmp6.override { withStatic = true; }}/lib"
        "--extra-lib-dirs=${pkgs.libffi.overrideAttrs (old: { dontDisableStatic = true; })}/lib"
      ];
    })
    drv;

  ## Define a function that makes this app installable in Nix environment with all its dependencies:
  makeAppInstallable = drv: drv.overrideAttrs (oldAttrs: rec {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      pkgs.makeWrapper
    ];

    postFixup = (oldAttrs.postFixup or "") + ''
      wrapProgram $out/bin/haskell-static-compilation-example --prefix PATH : ${pkgs.lib.makeBinPath [ ]}
    '';
  });

  ## Get raw Haskell program derivation for this app:
  thisApp = haskell.callCabal2nixWithOptions "haskell-static-compilation-example" ./. "--no-check --no-haddock" { };
in
if doStatic then makeAppStatic thisApp else makeAppInstallable thisApp
