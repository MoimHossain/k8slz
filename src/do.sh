#!/usr/bin/env bash

cd ..
changedFiles=$(git diff-tree --no-commit-id --name-only -r 1e8f534)
echo $changedFiles

for d in src/governance/*/ ; do
    echo "$d"
done