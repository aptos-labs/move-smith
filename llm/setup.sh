#!/bin/bash

set -e

git submodule update --init --recursive

if [ ! -d ".venv" ]; then
    python -m venv .venv
fi
source .venv/bin/activate
pip install -r requirements.txt
deactivate

mkdir -p data/raw
cd data/raw

# TODO: once repo structure is stable, use git submodule
echo "Downloading developer docs"
git clone git@github.com:aptos-labs/developer-docs.git

echo "Downloading mainnet source code"
git clone git@github.com:aptos-labs/mainnet-source-code.git

ln -s ~/aptos-core/third_party/move/move-compiler-v2/transactional-tests/tests compiler-test
