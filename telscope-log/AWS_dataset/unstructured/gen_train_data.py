import os
import random
from random import shuffle

import pandas as pd
from pandas.core.frame import DataFrame
from sklearn.model_selection import train_test_split
import sys

def data_read(filepath):
    with open(filepath, "r") as fp:
        datas = []  # 存储处理后的数据
        lines = fp.readlines()  # 读取整个文件数据
        i = 0  # 为一行数据
        for line in lines:
            row = line.strip()
            # row = line.strip('\n').split(' ')  # 去除两头的换行符，按空格分割
            datas.append(row)
            i = i + 1
    return datas

def data_write(data, filepath):
    with open(filepath, "w") as f:
        for line in data:
            f.write('%s\n' % line)


#hdfs_train = data_read('data/hdfs_train')
#hdfs_test_normal = data_read('data/hdfs_test_normal')
#hdfs_test_abnormal = data_read('data/hdfs_test_abnormal')
#hdfs_train.extend(hdfs_test_normal)
#normal_all = hdfs_train
#abnormal = hdfs_test_abnormal
normal = data_read('indexed_normal.txt')
abnormal = data_read('indexed_abnormal.txt')
train_normal, test_normal = train_test_split(normal, test_size=0.1, random_state=42)
#test_normal,valid_normal = train_test_split(test_normal, test_size=0.5, random_state=42)
#test_normal.extend(valid_normal)
train_abnormal, test_abnormal = train_test_split(abnormal, test_size=0.1, random_state=42)
#test_abnormal,valid_abnormal = train_test_split(test_abnormal, test_size=0.5, random_state=42)
#test_abnormal.extend(valid_abnormal)

# use train_normal, test_normal, test_abnormal only

data_write(train_normal, 'unsup-train.txt')
data_write(test_normal, 'unsup-test-normal.txt')
data_write(test_abnormal, 'unsup-test-abnormal.txt')

sys.exit(1)

#print(len(normal_all))
#max_len = 0
#for i in range(len(normal_all)):
#    leng = len(normal_all[i])
    # if leng>200:
    # print(i)
    # print(normal_all[i])
#    max_len = max([max_len, leng])
#print(max_len)


random.seed(42)

#shuffle(normal_all)
#shuffle(abnormal)

#train_normal = normal_all[:6000]
#valid_normal = normal_all[6000:7000]
#test_normal = normal_all[6000:]

#train_abnormal = abnormal[:6000]
#valid_abnormal = abnormal[6000:7000]
#test_abnormal = abnormal[6000:]

train_all = train_normal + train_abnormal
train_all_label = [0] * len(train_normal) + [1] * len(train_abnormal)

valid_all = valid_normal + valid_abnormal
valid_all_label = [0] * len(valid_normal) + [1] * len(valid_abnormal)

test_all = test_normal + test_abnormal
test_all_label = [0] * len(test_normal) + [1] * len(test_abnormal)

train_new = DataFrame({"Sequence": train_all, "label": train_all_label})
valid_new = DataFrame({"Sequence": valid_all, "label": valid_all_label})
test_new = DataFrame({"Sequence": test_all, "label": test_all_label})

train_new.to_csv('train.csv', index=None)
valid_new.to_csv('valid.csv', index=None)
test_new.to_csv('test.csv', index=None)
