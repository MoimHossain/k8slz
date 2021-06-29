#!/usr/bin/env bash

cd ..
changedFiles=$(git diff-tree --no-commit-id --name-only -r b7b1b3e)
workloads=()
for d in src/governance/*/ ; do  
    if [[ $changedFiles == *"$d"* ]]; then
    workloads+=($d)
    fi
done
cd src
for wl in ${workloads[@]}; do
    workloadName="$(basename $wl)"
    echo "<<$workloadName>> changed (full path: $wl)"
    ./generate-kubeconfig.sh $workloadName
    cd "./governance/$workloadName/github"
    terraform init && terraform apply -auto-approve
    cd ../../../
    ls
done