#!/bin/bash

set -e

for z in "$@"; do
    cp -a "$z" ../ocr/z.jpg
    read NUMBER
    echo $NUMBER $z >> ../ocr/ocr-results.txt
done

rm ../ocr/z.jpg
