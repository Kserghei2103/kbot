APP=$(shell basename $(shell git remote get-url origin))
REGESTRY=kserghei2103

VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64

linux:
	$(MAKE) image TARGETOS=linux TARGETARCH=${TARGETARCH}

windows:
	$(MAKE) image TARGETOS=windows TARGETARCH=${TARGETARCH}

macos:
	$(MAKE) image TARGETOS=darwin TARGETARCH=${TARGETARCH}


format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v	

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/vit-um/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGESTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi -f ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}