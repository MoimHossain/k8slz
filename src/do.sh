#!/usr/bin/env bash

cd ..
changedFiles=$(git diff-tree --no-commit-id --name-only -r b7b1b3e)
echo $changedFiles

for d in src/governance/*/ ; do  
    if [[ $changedFiles == *"$d"* ]]; then
    workloadName="$(basename $d)"
    echo "$workloadName changed (full path: $d)"
    fi
done