SITE_BUILD_ROOT = ./_site/
SITE_BUILD = $(SITE_BUILD_ROOT)*
SITE_ROOT = /var/www/static
RESUME_GIT = git://github.com/mishok13/cv.git
RESUME_NAME = cv.tex

.PHONY: build fullinstall install clean resume

clean:
	rm -rf $(SITE_BUILD)

build:
	mkdir -p $(SITE_BUILD_ROOT)
	git pull
	blogofile build

install:
	cp -R $(SITE_BUILD) $(SITE_ROOT)

fullinstall: clean resume build install

resume:
	rm -rf cv
	git clone $(RESUME_GIT) cv
	pdflatex -output-directory cv cv/cv.tex
	mkdir -p resume
	cp cv/cv.pdf resume/resume.pdf
	
