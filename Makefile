# -*- mode:makefile-gmake -*-

all:
.PHONY: all publish

package_directory := ./package

$(package_directory):
	mkdir -p $@

module_files :=

module_files += $(package_directory)/package.json
$(package_directory)/package.json: package.json | $(package_directory)
	cp $< $@

module_files += $(package_directory)/agh.sprintf.js
$(package_directory)/agh.sprintf.js: agh.sprintf.js | $(package_directory)
	cp $< $@

module_files += $(package_directory)/agh.sprintf.min.js
$(package_directory)/agh.sprintf.min.js: agh.sprintf.js | $(package_directory)
	uglifyjs -m -c -o $@ $<
#	uglifyjs -m -c -o agh.sprintf.min.tmp $<
#	gzjs -Wsfx85 -o$@ agh.sprintf.min.tmp

module_files += $(package_directory)/README.md $(package_directory)/LICENSE.md
$(package_directory)/README.md: README.md | $(package_directory)
	cp $< $@
$(package_directory)/LICENSE.md: LICENSE.md | $(package_directory)
	cp $< $@

module_files += $(package_directory)/example.js $(package_directory)/example.html
$(package_directory)/example.js: example.js | $(package_directory)
	cp $< $@
$(package_directory)/example.html: example.html | $(package_directory)
	cp $< $@

all: $(module_files)
publish: $(module_files)
	cd $(package_directory); npm publish
