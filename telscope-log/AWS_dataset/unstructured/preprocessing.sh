#!/bin/bash
python preprocessing.py attack.csv AWS_abnormal_log.csv
python preprocessing.py normal.csv AWS_normal_log.csv
