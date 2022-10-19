SHELL:=/usr/bin/env sh

OSFLAG := ""
UNAME := $(shell uname -m)
ifeq ($(UNAME), arm64)
  OSFLAG = DOCKER_DEFAULT_PLATFORM=linux/amd64
endif

# Build bsc binary docker
.PHONY:build-bsc
build-bsc:
	$(OSFLAG) docker-compose -f docker-compose.bsc.yml build

# Build & start simple validator cluster

.PHONY:build-simple
build-simple:
	make build-bsc
	$(OSFLAG) docker-compose -f docker-compose.simple.bootstrap.yml build
	$(OSFLAG) docker-compose -f docker-compose.simple.yml build

.PHONY:bootstrap-simple
bootstrap-simple:
	$(OSFLAG) docker-compose -f docker-compose.simple.bootstrap.yml run bootstrap-simple

.PHONY:start-simple
start-simple:
	$(OSFLAG) docker-compose -f docker-compose.simple.yml up -d bsc-rpc bsc-validator1 netstats

.PHONY:run-test-simple
run-test-simple:
	docker-compose -f docker-compose.simple.yml run truffle-test

# Build & start multiple validator cluster

.PHONY:build-cluster
build-cluster:
	make build-bsc
	$(OSFLAG) docker-compose -f docker-compose.cluster.bootstrap.yml build
	$(OSFLAG) docker-compose -f docker-compose.cluster.yml build

.PHONY:bootstrap-cluster
bootstrap-cluster:
	$(OSFLAG) docker-compose -f docker-compose.cluster.bootstrap.yml run bootstrap-cluster

.PHONY:start-cluster
start-cluster:
	$(OSFLAG) docker-compose -f docker-compose.cluster.yml up -d cluster-bsc-rpc cluster-bsc-validator1 cluster-bsc-validator2 cluster-bsc-validator3 netstats

.PHONY:run-test-cluster
run-test-cluster:
	docker-compose -f docker-compose.cluster.yml run truffle-test

# Stop & reset

.PHONY:stop-all
stop-all:
	docker-compose -f docker-compose.simple.yml stop
	docker-compose -f docker-compose.cluster.yml stop
	docker container prune -f

.PHONY:reset
reset:
	make stop-all
	rm -rf storage/*
	docker system prune -f