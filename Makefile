# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.


include .env

.PHONY: dpeth android ios dpeth-cross swarm evm all test clean
.PHONY: dpeth-linux dpeth-linux-386 dpeth-linux-amd64 dpeth-linux-mips64 dpeth-linux-mips64le
.PHONY: dpeth-linux-arm dpeth-linux-arm-5 dpeth-linux-arm-6 dpeth-linux-arm-7 dpeth-linux-arm64
.PHONY: dpeth-darwin dpeth-darwin-386 dpeth-darwin-amd64
.PHONY: dpeth-windows dpeth-windows-386 dpeth-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

dpeth:
	build/env.sh go run build/ci.go install ./cmd/dpeth
	@echo "Done building."
	@echo "Run \"$(GOBIN)/dpeth\" to launch dpeth."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/dpeth.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/Geth.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

dpeth-cross: dpeth-linux dpeth-darwin dpeth-windows dpeth-android dpeth-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-*

dpeth-linux: dpeth-linux-386 dpeth-linux-amd64 dpeth-linux-arm dpeth-linux-mips64 dpeth-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-*

dpeth-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/dpeth
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep 386

dpeth-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/dpeth
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep amd64

dpeth-linux-arm: dpeth-linux-arm-5 dpeth-linux-arm-6 dpeth-linux-arm-7 dpeth-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep arm

dpeth-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/dpeth
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep arm-5

dpeth-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/dpeth
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep arm-6

dpeth-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/dpeth
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep arm-7

dpeth-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/dpeth
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep arm64

dpeth-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/dpeth
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep mips

dpeth-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/dpeth
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep mipsle

dpeth-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/dpeth
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep mips64

dpeth-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/dpeth
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-linux-* | grep mips64le

dpeth-darwin: dpeth-darwin-386 dpeth-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-darwin-*

dpeth-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/dpeth
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-darwin-* | grep 386

dpeth-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/dpeth
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-darwin-* | grep amd64

dpeth-windows: dpeth-windows-386 dpeth-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-windows-*

dpeth-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/dpeth
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-windows-* | grep 386

dpeth-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/dpeth
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/dpeth-windows-* | grep amd64


COMPOSE = docker-compose -f docker-compose.yaml

# docker制作后的镜像路径
ifeq ($(repo_url),)
	appImg="${app}:${tag}"
else
	appImg="${repo_url}/${app}:${tag}"
endif

default: run

.PHONY: build
build: dpeth

.PHONY: buildall
buildall: all

.PHONY: docker
docker:
#docker: build
	docker build . -t $(appImg) --build-arg app=${app}


.PHONY: push
push: docker
	docker push $(appImg)


#查看服务状态
ps:
	$(COMPOSE) ps

#跟踪业务日志，可传APP变量
logsf:
	$(COMPOSE) logs -f --tail=100

#查看业务日志，可传APP变量
logs:
	$(COMPOSE) logs

#启动某个服务
run:
	$(COMPOSE) up -d

# 重启服务，可传APP变量
restart:
	@$(COMPOSE) restart $(APP)

# 停止所有服务
stop:
	$(COMPOSE) stop $(APP)



# for debug use
FILE = Makefile.test
ifeq ($(FILE), $(wildcard $(FILE)))
include Makefile.test
endif