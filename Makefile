# vim:ft=make:

# ── OS / arch detection ───────────────────────────────────────────────────────
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Install scripts download linux-amd64 binaries, so pin the platform.
# On Apple Silicon this uses Rosetta 2 / QEMU emulation transparently.
PLATFORM := linux/amd64

ifeq ($(UNAME_S),Darwin)
	OPEN := open
else
	OPEN := xdg-open
endif

# ── Names ─────────────────────────────────────────────────────────────────────
SLIM_IMAGE := tty-puppet-master
FAT_IMAGE  := kali-puppet-master
REGISTRY   := ghcr.io/benjitrapp/puppet-master

# ── Default ───────────────────────────────────────────────────────────────────
.DEFAULT_GOAL := help

.PHONY: all help build_slim build_fat start_slim start_fat browser clean

all: build_slim build_fat ## Build both images

help: ## Show available targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

# ── Build ─────────────────────────────────────────────────────────────────────
build_slim: ## Build the slim ttyd image (Sliver · Merlin · PoshC2)
	docker buildx build \
		--platform $(PLATFORM) \
		--load \
		-t $(SLIM_IMAGE) \
		-f Dockerfile \
		.

build_fat: ## Build the full Kali image (noVNC desktop + all C2 frameworks)
	docker buildx build \
		--platform $(PLATFORM) \
		--load \
		-t $(FAT_IMAGE) \
		-f Dockerfile.fat \
		.

# ── Run ───────────────────────────────────────────────────────────────────────
start_slim: ## Run the slim image — web terminal on http://localhost:7681
	docker run --rm -it \
		--platform $(PLATFORM) \
		-p 7681:7681 \
		--name $(SLIM_IMAGE) \
		$(REGISTRY):main

start_fat: ## Run the fat image — noVNC on :9020, raw VNC on :5900
	docker run --rm -it \
		--platform $(PLATFORM) \
		-p 9020:8080 \
		-p 9021:5900 \
		--name $(FAT_IMAGE) \
		$(FAT_IMAGE)

browser: ## Open the noVNC desktop in the default browser
	$(OPEN) 'http://localhost:9020/vnc.html'

# ── Cleanup ───────────────────────────────────────────────────────────────────
clean: ## Remove locally built images
	docker rmi $(SLIM_IMAGE) $(FAT_IMAGE) 2>/dev/null || true
