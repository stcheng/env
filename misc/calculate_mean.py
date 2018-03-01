#!/usr/bin/env python

# This script is to read the csv file with the following format
# key,value
# where the key is not unique and the value is associated with the key.
# Then, the script tries to calculate the mean value of each unique key
# and print out the result with the same format as above.

import csv
import sys

if len(sys.argv) != 2:
    print 'Usage: calculate_mean.py <csv_file_name>'
    exit(1)

file_name = sys.argv[1]

data_list = []

with open(file_name, 'rb') as f:
    reader = csv.reader(f)
    data_list = list(reader)

data_dict = {}

for data in data_list:
    key = data[0]
    value = float(data[1])
    if key in data_dict:
        data_dict[key].append(value)
    else:
        data_dict[key] = [value]

for key in data_dict:
    sys.stdout.write(key + ',')
    print sum(data_dict[key])/len(data_dict[key])
