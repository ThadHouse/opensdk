mk_file_dir := $(abspath $(shell dirname $(MAKE)))

WPI_HOST ?= $(shell sh $(mk_file_dir)/utils/extra/guess-host.sh)
WPI_TARGET ?= roborio
WPI_TARGET_PORT ?= cortexa9_vfpv3
USE_DOCKER ?= false


ifeq ($(USE_DOCKER), true)
	runner := $(mk_file_dir)/docker.sh
	workdir := /work
else
	runner :=
	workdir := $(PWD)
endif

.PHONY: any frontend backend test clean

any:
	@echo "Please manually select a command such as frontend, backend, sign, test, or clean."
	@/bin/false

# Do note that the current implementations of frontend and backend could have
# name collisions if the tuple is the same. (roborio sumo vs. roborio-hardknott)

frontend:
	$(runner) bash ./utils/build-frontend.sh \
		${workdir}/hosts/${WPI_HOST}.env \
		${workdir}/targets/${WPI_TARGET} \
		${WPI_TARGET_PORT}

backend:
	$(runner) bash ./utils/build-backend.sh \
		${workdir}/hosts/${WPI_HOST}.env \
		${workdir}/targets/${WPI_TARGET} \
		${WPI_TARGET_PORT}

sign:
	$(runner) bash ./utils/sign-toolchain.sh \
		${workdir}/hosts/${WPI_HOST}.env \
		${workdir}/targets/${WPI_TARGET} \
		${WPI_TARGET_PORT}

test:
	$(runner) bash ./utils/test-toolchain.sh \
		${workdir}/hosts/${WPI_HOST}.env \
		${workdir}/targets/${WPI_TARGET} \
		${WPI_TARGET_PORT}

clean:
	$(runner) rm -rf build downloads || true
