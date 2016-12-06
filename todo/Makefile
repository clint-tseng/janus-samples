default: build

SRC = $(shell find src -name "*.coffee" -type f | sort)
LIB = $(SRC:src/%.coffee=lib/%.js)

lib:
	mkdir -p lib/

lib/%.js: src/%.coffee lib node_modules
	node node_modules/coffee-script/bin/coffee --output "$(@D)" --compile "$<"

lib/app.html: src/app.html lib
	cp src/app.html lib/

node_modules:
	npm install

build: $(LIB) lib/app.html

test: build node_modules
	node node_modules/mocha/bin/mocha --compilers coffee:coffee-script/register --recursive

clean:
	rm -rf lib

