#!/usr/bin/env bash

echo "Detecting changes...${{ github.sha }}"
cd ..
changedFiles=$(git diff-tree --no-commit-id --name-only -r ${{ github.sha }}) # b7b1b3e
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

    kubectl apply -f "./governance/$workloadName/k8s/namespace.yaml"
    kubectl apply -f "./governance/$workloadName/k8s/service-account.yaml"
    kubectl apply -f "./governance/$workloadName/k8s/role.yaml"
    kubectl apply -f "./governance/$workloadName/k8s/role-binding.yaml"

    ./generate-kubeconfig.sh $workloadName
    cd "./governance/$workloadName/github"
    terraform init && terraform apply -auto-approve
    rm -rf .terraform
    rm -rf .terraform.lock.hcl
    rm -rf kubeconfig
    cd ../../../    
done