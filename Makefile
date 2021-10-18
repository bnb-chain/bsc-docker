SHELL:=/usr/bin/env sh

# Build bsc binary docker
.PHONY:build-bsc
build-bsc:
	docker-compose -f docker-compose.bsc.yml build


# Build & start simple validator cluster

.PHONY:build-simple
build-simple:
	make build-bsc
	docker-compose -f docker-compose.simple.bootstrap.yml build
	docker-compose -f docker-compose.simple.yml build

.PHONY:bootstrap-simple
bootstrap-simple:
	docker-compose -f docker-compose.simple.bootstrap.yml run bootstrap-simple

.PHONY:start-simple
start-simple:
	docker-compose -f docker-compose.simple.yml up -d bsc-rpc bsc-validator1 netstats

.PHONY:run-test-simple
run-test-simple:
	docker-compose -f docker-compose.simple.yml run truffle-test

# Build & start multiple validator cluster

.PHONY:build-cluster
build-cluster:
	make build-bsc
	docker-compose -f docker-compose.cluster.bootstrap.yml build
	docker-compose -f docker-compose.cluster.yml build

.PHONY:bootstrap-cluster
bootstrap-cluster:
	docker-compose -f docker-compose.cluster.bootstrap.yml run bootstrap-cluster

.PHONY:start-cluster
start-cluster:
	docker-compose -f docker-compose.cluster.yml up -d cluster-bsc-rpc cluster-bsc-validator1 cluster-bsc-validator2 cluster-bsc-validator3 netstats

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