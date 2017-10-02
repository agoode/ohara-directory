#!/usr/bin/python

import csv
import sys

cols = {}

# read
with open(sys.argv[1], 'rb') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        col = 0
        for v in row:
            cols.setdefault(col, []).append(v)
            col = col + 1

# write
for k in sorted(cols):
    for line in cols[k]:
        print line
