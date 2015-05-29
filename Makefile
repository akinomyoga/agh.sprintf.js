# -*- mode:makefile-gmake -*-

all:
.PHONY: all

all: agh.sprintf.min.js
agh.sprintf.min.js: agh.sprintf.js
	uglifyjs $< > agh.sprintf.min.tmp
	gzjs -Wsfx -o$@ agh.sprintf.min.tmp