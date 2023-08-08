PROJECT=keycloak
REPO=registry.rc.nectar.org.au/nectar

SHA=$(shell git rev-parse --verify --short HEAD)
TAG_PREFIX=
IMAGE_TAG := $(if $(TAG),$(TAG),$(TAG_PREFIX)$(SHA))
IMAGE=$(REPO)/$(PROJECT):$(IMAGE_TAG)
BUILDER=docker
BUILDER_ARGS=--no-cache


build:
	# No scripts required at the moment
	#cd scripts; zip ../nectar-scripts.jar -r *; cd ..
	$(BUILDER) build $(BUILDER_ARGS) -t $(IMAGE) .

push:
	$(BUILDER) push $(IMAGE)

.PHONY: build push
