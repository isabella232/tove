#!/bin/bash
set -e
trap 'error ${LINENO}' ERR

rm -rf workload_dir
mkdir workload_dir
echo -n "hello" > workload_dir/file1

rm -rf traces_dir
mkdir traces_dir

rm -rf bin
mkdir bin

go build -o bin/workload workload/workload.go
go build -o bin/checker checker/checker.go

alice-record --workload_dir workload_dir \
	--traces_dir traces_dir \
	bin/workload

alice-check --threads=4 --traces_dir=traces_dir --checker=bin/checker
#./bin/checker workload_dir <(echo -e "kv1=v1\ndel k1")

