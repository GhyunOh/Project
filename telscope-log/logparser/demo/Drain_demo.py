#!/usr/bin/env python
import sys
sys.path.append('../')
from logparser import Drain

input_dir  = '../logs/HDFS/'  # The input directory of log file
output_dir = 'Drain_result/'  # The output directory of parsing results
log_file   = 'HDFS_2k.log'  # The input log file name
log_format = '<Date> <Time> <Content>'  # HDFS log format
# Regular expression list for optional preprocessing (default: [])

regex      = [r'([?:\s-](\s))']


st         = 0.5  # Similarity threshold
depth      = 4  # Depth of all leaf nodes

parser = Drain.LogParser(log_format, indir=input_dir, outdir=output_dir,  depth=depth, st=st, rex=regex)
parser.parse(log_file)

