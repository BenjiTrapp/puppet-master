
<p align="center">
<img width=400 src="/docs/puppet-master.png">
</p>

##### Disclamer:
> I'm not responsible for any harm caused by this tool. The provided docker image is part of my curiosity and used for CTFs and education only. Use these powers wisely and stay on the light side!


## Tighten the strings and have some fun with your puppets

This Docker image is build on top of a minimal base install of the latest version of the Kali Linux Rolling Distribution and enriched with additional capabilities to transform it into a [C2 Server](https://www.paloaltonetworks.com/cyberpedia/command-and-control-explained) to aid during Pentesting engagements, CTFs or for other sakes.

For a Kickstart use the Makefile: `make all` and watch the magic of the puppet master by browsing to [http://127.0.0.1:6080/](http://127.0.0.1:6080/)

## Not ready to get mesmerized yet?

Build the image: `docker build -t puppet-master .` or run `make build`


Run the docker image and open port 6080:

`docker run -it -d --rm --name puppet-master -p 6080:8080 puppet-master` or `make run`

## VNC and play with the puppets

First at all: Browse to [http://127.0.0.1:6080/](http://127.0.0.1:6080/)

Forward VNC service port 5900 to host by

`docker run -it --rm -p 6080:80 -p 5900:5900 puppet-master`

Now, open the vnc viewer and connect to port 5900. If you would like to protect the VNC service by password, set environment variable VNC_PASSWORD.

For example:

`docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword puppet-master`

A prompt will ask password either in the browser or vnc viewer.

## To get into bash of the running container

`sudo docker exec -i -t puppet-master /bin/bash`

P.S. If you are going to run container in cloud virtual machine, first run the bellow command to virtual machine in cloud to create ssh tunnel to your virtual machine

`ssh -i .ssh/private_key -L 6080:localhost:6080 -L 5900:localhost:5900 user@IP`

## Content 

**Kali metapackages [https://tools.kali.org/kali-metapackages]**:
* kali-tools-top10
* kali-desktop-gnome
* kali-tools-fuzzing
* kali-tools-passwords
* kali-tools-post-exploitation
* kali-tools-sniffing-spoofing

**C2 Capabilities**:
* Metasploit
* Covenant
* SilentTrinity
* Empire
* StarKiller
* PoshC2
* Merlin
