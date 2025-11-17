#!/bin/bash

set -e

# --- Configuration ---
MODELS_DIR="./models"
MODEL_NAME="Qwen3-4B-Thinking-2507"
MODEL_REPO="https://huggingface.co/Qwen/Qwen3-4B-Thinking-2507"
MODEL_PATH="${MODELS_DIR}/${MODEL_NAME}"

# --- Prerequisite Check ---
echo "### Checking for required tools..."
command -v git >/dev/null 2>&1 || { echo >&2 "Git is not installed. Please install it to continue."; exit 1; }
command -v git-lfs >/dev/null 2>&1 || { echo >&2 "Git LFS is not installed. Please install it to continue."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo >&2 "Docker is not installed. Please install it to continue."; exit 1; }
echo "### All required tools are available."
echo ""

# --- Model Download ---
echo "### Setting up the models directory..."
mkdir -p "${MODELS_DIR}"
cd "${MODELS_DIR}"

echo "### Initializing Git LFS..."
git lfs install

echo "### Cloning the model: ${MODEL_NAME}..."
# Only clone the repository if the directory doesn't already exist
if [ ! -d "${MODEL_NAME}" ]; then
  GIT_LFS_SKIP_SMUDGE=0 git clone "${MODEL_REPO}"
else
  echo "Model directory '${MODEL_NAME}' already exists. Skipping clone."
fi

cd ../
echo ""

# --- Docker Compose Steps ---
echo "### Running model conversion..."
docker-compose run --rm convert
echo ""

echo "### Running model quantization..."
docker-compose run --rm quantize
echo ""

echo "### Starting the Llama.cpp server..."
docker-compose up -d server
echo ""

# --- Final Status ---
echo "### Docker container status:"
docker ps -a
echo ""
echo "### The Llama.cpp server should now be running."
echo "### You can access it at: http://localhost:8080"