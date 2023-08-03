{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
        pkgs = nixpkgs.legacyPackages.${system};

        cousine-font = pkgs.fetchurl {
          url = "https://github.com/google/fonts/raw/main/apache/cousine/Cousine-Regular.ttf";
          sha256 = "sha256-aeHqWet3ABQgTlF0+AV1D5p5PbSiUx5lFrMLdGDUcLM=";
        };

        comic-shans-font = pkgs.fetchurl {
          url = "https://github.com/shannpersand/comic-shanns/raw/master/v2/comic%20shanns.otf";
          sha256 = "sha256-ogAILIIBbTnwUYzUSdX6VIbbSo7kuXihDUOZpVo1fVQ=";
        };
      in {
        packages.neo-comic-mono = pkgs.stdenv.mkDerivation rec {
          pname = "Neo Comic Mono";
          version = "0.0.1";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            python311
            python311Packages.fontforge
          ];

          buildPhase = ''
            mkdir -p vendor build

            ln -sf "${cousine-font}" vendor/cousine.ttf
            ln -sf "${comic-shans-font}" vendor/comic-shanns.otf

            python generate.py
          '';

          installPhase = ''
            install -m444 -Dt "$out" "build/"*.ttf
          '';
        };

        defaultPackage = self.packages.${system}.neo-comic-mono;
      }
    );
}
