# vim:ft=make:

.PHONY : all start build_fat github

all: github

build_fat:
		docker build -t kali-puppet-master -f Dockerfile.fat

build_slim:
		docker build -t tty-puppet-master -f Dockerfile

build_slim_m2:
		docker build --platform linux/x86_64 -t tty-puppet-master -f Dockerfile

github:
		docker pull ghcr.io/benjitrapp/puppet-master:nightly
		docker run --rm -it -p 9020:8080 -p 9021:5900 ghcr.io/benjitrapp/puppet-master:nightly puppet-master

clean:
		docker rmi puppet-master

start_fat:
		docker run --rm -it -p 9020:8080 -p 9021:5900 --name kali-puppet-master kali-puppet-master

start_slim_m2:
		docker run --platform linux/amd64 --rm -it -p 7681:7681 --name tty-puppet-master tty-puppet-master

stop:
		docker rm -f puppet-master

browser:
		browse 'http://localhost:9020/vnc.html' | sh -e
