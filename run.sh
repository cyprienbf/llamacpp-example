#!/bin/bash

mkdir models
cd ./models

git lfs install
GIT_LFS_SKIP_SMUDGE=0 git clone https://huggingface.co/Qwen/Qwen3-4B-Thinking-2507

cd ../

echo ""

docker-compose run --rm convert

echo ""
    
docker-compose run --rm quantize

echo ""

docker-compose up -d server

wait
