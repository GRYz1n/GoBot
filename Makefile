APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ghcr.io/gryz1n
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #amd64 arm64 

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/github.com/GRYz1n/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

clean:
	rm -rf kbot
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)