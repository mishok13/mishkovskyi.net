SITE_BUILD_ROOT = ./_site/
SITE_BUILD = $(SITE_BUILD_ROOT)*
SITE_ROOT = /var/www/static
RESUME_GIT = git://github.com/mishok13/cv.git
RESUME_NAME = cv.tex

.PHONY: build reinstall install clean resume

clean:
	rm -rf $(SITE_BUILD)

build:
	mkdir -p $(SITE_BUILD_ROOT)
	git pull
	blogofile build

install: build
	cp -R $(SITE_BUILD) $(SITE_ROOT)

reinstall: clean install

resume:
	rm -rf cv
	git clone $(RESUME_GIT) cv
	pdflatex -output-directory cv cv/cv.tex
	cp cv.pdf $(SITE_BUILD_ROOT)resume/resume.odf
