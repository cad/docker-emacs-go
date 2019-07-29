.PHONY: build run
build:
	docker build --rm  -t emacs .

run:
	docker run --rm -it -v /home/cad/:/workspace  -v /home/cad/emacs-gopls:/go/pkg/mod emacs
