#!/bin/sh

OLD=20160825
NEW=20160829

for z in K 1 2 3 4 5; do
    for y in $OLD $NEW; do
        python transpose-csv.py classlist-$z-$y.csv > classlist-transposed-$z-$y.csv
    done
    echo "*** $z ***"
    diff -uwB classlist-transposed-$z-$OLD.csv classlist-transposed-$z-$NEW.csv
    echo
done
