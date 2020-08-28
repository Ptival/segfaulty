let

  name = "segfaulty";
  compiler-nix-name = "ghc883";

  sources = import ./nix/sources.nix {};
  haskellNix = import (fetchTarball { inherit (sources."haskell.nix") url sha256; }) {};
  all-hies = import (fetchTarball { inherit (sources.all-hies) url sha256; }) {};

  pkgs = import haskellNix.sources.nixpkgs-2003 (haskellNix.nixpkgsArgs // {
    overlays = haskellNix.nixpkgsArgs.overlays ++ [
      all-hies.overlay
    ];
  });

  set = pkgs.haskell-nix.cabalProject {

    inherit compiler-nix-name;

    src = pkgs.haskell-nix.haskellLib.cleanGit {
      inherit name;
      src = ./.;
    };

  };

in

set.${name}.components.library // {

  shell = set.shellFor {

    exactDeps = true;

    packages = p: [
      p.segfaulty
    ];

    tools = {
      cabal = "3.2.0.0";
      hie = "unstable";
      hpack = "0.34.2";
    };

  };

}
