SITE_BUILD_ROOT = ./_site/
SITE_BUILD = $(SITE_BUILD_ROOT)*
SITE_ROOT = /var/www/static

.PHONY: build reinstall install clean

clean:
	rm -rf $(SITE_BUILD)

build:
	mkdir -p $(SITE_BUILD_ROOT)
	git pull
	blogofile build

install: build
	cp -R $(SITE_BUILD) $(SITE_ROOT)

reinstall: clean install
