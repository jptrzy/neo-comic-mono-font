
all: clean main

clean:
	rm -rf build/* down

main:
	mkdir -p build
	python generate.py

install: main
	mkdir -p /usr/share/fonts/neo-comic
	cp build/* /usr/share/fonts/neo-comic
	
download:
	mkdir -p down vendor
	wget https://www.ffonts.net/Cousin.font.zip -O down/cousin.zip
	unzip -u down/cousin.zip -d down
	cp down/*.ttf vendor/cousine.ttf
	wget https://github.com/shannpersand/comic-shanns/raw/master/v2/comic%20shanns.otf -O vendor/comic-shanns.otf
	rm -rf down
	

