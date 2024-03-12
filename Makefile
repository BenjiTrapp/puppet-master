# vim:ft=make:

.PHONY : all build_fat build_slim github

all: github

## Kali based image that contains various C2 options
build_fat:
		docker build -t kali-puppet-master -f Dockerfile.fat

## "Slim" TTY based image that contains Sliver and Merlin
build_slim:
		docker build -t tty-puppet-master -f Dockerfile

start_fat:
		docker run --rm -it -p 9020:8080 -p 9021:5900 --name kali-puppet-master kali-puppet-master

start_slim:
		docker run --rm -it -p 7681:7681 --name tty-puppet-master ghcr.io/benjitrapp/puppet-master:nightly
browser:
		browse 'http://localhost:9020/vnc.html' | sh -e
