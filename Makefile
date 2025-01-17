-include env_make

VERSION ?= 8.11.3
FROM ?= solr:8.11.3-slim
TAG ?= $(VERSION)

IMAGE ?= devkteam/solr
BUILD_IMAGE_TAG ?= $(IMAGE):$(VERSION)-build
NAME = devkteam-solr-$(VERSION)
SOLR_DEFAULT_CONFIG_SET ?= search_api_solr_4.3.3
INCLUDE_EXTRAS ?= 0

ifneq ($(STABILITY_TAG),)
	ifneq ($(TAG),latest)
		override TAG := $(TAG)-$(STABILITY_TAG)
	endif
endif

.PHONY: build test push shell run start stop logs clean release

build:
	git checkout -- configsets
	VERSION=$(VERSION) scripts/prepare_configsets.sh
	docker build -t $(BUILD_IMAGE_TAG) --build-arg FROM=$(FROM) --build-arg VERSION=$(VERSION) --build-arg SOLR_DEFAULT_CONFIG_SET=$(SOLR_DEFAULT_CONFIG_SET) .

build-multi:
	git checkout -- configsets
	VERSION=$(VERSION) scripts/prepare_configsets.sh
	docker \
		buildx \
		build \
		--push \
		--platform linux/amd64,linux/arm64 \
		-t $(BUILD_IMAGE_TAG) \
		--build-arg INCLUDE_EXTRAS=$(INCLUDE_EXTRAS) \
		--build-arg FROM=$(FROM) \
		--build-arg VERSION=$(VERSION) \
		--build-arg SOLR_DEFAULT_CONFIG_SET=$(SOLR_DEFAULT_CONFIG_SET) \
		.

test:
	IMAGE=$(REPO):$(TAG) NAME=$(NAME) VERSION=$(VERSION) ./tests/test.bats

push:
	docker push $(REPO):$(TAG)

shell: clean
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(BUILD_IMAGE_TAG) /bin/bash

run: clean
	docker run --rm --name $(NAME) -it -d $(PORTS) $(VOLUMES) $(ENV) $(BUILD_IMAGE_TAG)

start: clean
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(BUILD_IMAGE_TAG)

exec:
	docker exec $(NAME) /bin/bash -c "$(CMD)"

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm -f $(NAME) >/dev/null 2>&1 || true

release: build push

default: build
