.PHONY: build run
build:
	docker build --rm  -t emacs .

run:
	docker run --rm -it -v /home/cad/:/workspace emacs
