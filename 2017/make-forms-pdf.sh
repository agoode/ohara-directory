#!/bin/bash

set -e -x

mkdir -p united

while read -r zz
do
    z=$(echo $zz | sed 's/\r$//')
    files="forms/teacher_${z}_.pdf "
    for y in $(ls forms/${z}_*_.pdf | sort -V)
    do
        files=" ${files} ${y}"
    done
    files=" ${files} forms/_0.pdf forms/_0.pdf forms/_0.pdf united/${z}.pdf"
    pdfunite $files
done < teacher-files.txt

mkdir -p shared
for z in K 1 2 3 4 5; do
    {
        file=$(mktemp)
        pdfunite united/${z}_*.pdf "$file"
        #ps2pdf14 "$file" shared/${z}-merged-forms.pdf
        cp -av "$file" shared/${z}-merged-forms.pdf
        rm "$file"
    } &
done
