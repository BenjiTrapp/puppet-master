all: build run

build:
			docker pull kalilinux/kali-rolling
			docker build -t puppet-master .

run:
			docker run -it -d --rm --name puppet-master -p 6080:80 puppet-master