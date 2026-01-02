#!/bin/bash

set -e

mkdir models

cd ./models

git lfs install

GIT_LFS_SKIP_SMUDGE=0 git clone https://huggingface.co/Qwen/Qwen3-4B-Thinking-2507

docker-compose run --rm convert

docker-compose run --rm quantize

docker-compose up -d server
