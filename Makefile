# -*- mode:makefile-gmake -*-

all:
.PHONY: all

all: agh.sprintf.min.js
agh.sprintf.min.js: agh.sprintf.js
	uglifyjs -m -c -o $@ $<
#	uglifyjs -m -c -o agh.sprintf.min.tmp $<
#	gzjs -Wsfx85 -o$@ agh.sprintf.min.tmp
