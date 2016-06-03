#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")"
echo 'Removing dir out'
rm -rf out
echo 'Creating output structure'
mkdir out
cd out
mkdir newcerts
touch index.txt
echo 1000 > serial
echo 'Done'
