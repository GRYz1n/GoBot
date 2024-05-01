APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=ghcr.io/gryz1n/
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
#possible OS: linux, darwin, windows
TARGETARCH=amd64 #amd64 arm64 
#possible ARCH: amd64, arm, 386

format:
	gofmt -s -w ./

get:
	go get

lint:
	golint

test:
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/github.com/GRYz1n/kbot/cmd.appVersion=${VERSION}

image: format get build
	docker buildx build --platform ${TARGETOS}/${TARGETARCH} . -t ${REGISTRY}${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

push:
	docker push $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)

clean:
	rm -rf kbot
	docker rmi $(REGISTRY)/$(APP):$(VERSION)-$(TARGETOS)-$(TARGETARCH)