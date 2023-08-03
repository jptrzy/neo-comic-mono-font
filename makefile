build:
	nix build

install:
	install -m444 -Dt "/share/fonts/neo-comic" "build/"*.ttf
