.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/eeefan/dpeth/cmd/swarm
	go build -o bin/geth     github.com/eeefan/dpeth/cmd/geth
	go build -o bin/bootnode github.com/eeefan/dpeth/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/eeefan/dpeth/swarm/...
