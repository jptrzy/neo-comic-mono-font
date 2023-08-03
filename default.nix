let

  pkgs =  import <nixpkgs> {}; # bring all of Nixpkgs into scope

  cousine-font = pkgs.fetchurl {
    url = "https://github.com/google/fonts/raw/main/apache/cousine/Cousine-Regular.ttf";
    sha256 = "sha256-aeHqWet3ABQgTlF0+AV1D5p5PbSiUx5lFrMLdGDUcLM=";
  };

  comic-shans-font = pkgs.fetchurl {
    url = "https://github.com/shannpersand/comic-shanns/raw/master/v2/comic%20shanns.otf";
    sha256 = "sha256-ogAILIIBbTnwUYzUSdX6VIbbSo7kuXihDUOZpVo1fVQ=";
  };

in pkgs.stdenv.mkDerivation rec {
  pname = "neo-comic-mono-font";
  version = "0.0.1";

  src = ./.;

  buildInputs = with pkgs; [
    python311
    python311Packages.fontforge
    wget
    fontforge
  ];

  buildPhase = ''
    mkdir -p vendor build

    ln -sf "${cousine-font}" vendor/cousine.ttf
    ln -sf "${comic-shans-font}" vendor/comic-shanns.otf

    python generate.py
  '';

  installPhase = ''
    local out_font="$out/share/fonts/neo-comic"
    install -m444 -Dt "$out_font" "build/"*.ttf
  '';

  meta = with pkgs.lib; {
    description = "Mono font created basing on Comic Shanns";
    homepage = "https://github.com/jptrzy/neo-comic-mono-font";
    license = licenses.mit;
    maintainers = [ maintainers.jp3 ];
    platforms = platforms.all;
  };
}
