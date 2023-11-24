# vim:ft=make:

.PHONY : all start build github

all: github

build:
		docker build -t puppet-master .

github:
		docker pull ghcr.io/benjitrapp/puppet-master:nightly
		docker run --rm -it -p 9020:8080 -p 9021:5900 ghcr.io/benjitrapp/puppet-master:nightly puppet-master

clean:
		docker rmi puppet-master

start:
		docker run --rm -it -p 9020:8080 -p 9021:5900 --name puppet-master puppet-master

stop:
		docker rm -f puppet-master

browser:
		browse 'http://localhost:9020/vnc.html' | sh -e
