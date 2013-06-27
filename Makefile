COFFEEC = coffee

APPSRC := $(wildcard coffee/*.coffee)
APPOBJ := ${APPSRC:coffee/%.coffee=js/%.js}

.PHONY: build
build: ${APPOBJ}

js/%.js: coffee/%.coffee
	${COFFEEC} -cp $< > $@

