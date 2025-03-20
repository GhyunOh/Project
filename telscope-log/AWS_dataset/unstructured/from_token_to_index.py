import pandas as pd
import csv
import sys

#abnormal_log = sys.argv[1]
#normal_log = sys.argv[2]
abnormal_log = "AWS_abnormal_log.csv"
normal_log = "AWS_normal_log.csv"

data1 = pd.read_csv(abnormal_log, sep=",")
data2 = pd.read_csv(normal_log, sep=",")
data1.to_pickle('aws_data1.pickle')
data2.to_pickle('aws_data2.pickle')

import os
import csv
import copy
import pickle
import gensim
import numpy as np

with open('aws_data1.pickle','rb') as handler:
    adv_list1 = pickle.load(handler)
with open('aws_data2.pickle','rb') as handler:
    adv_list2 = pickle.load(handler)
#print(adv_list1.columns)
#print(type(adv_list1))
#print(len(adv_list1))
#adv_list = adv_list.astype({'Occurrences' : 'string'})
#adv_list['result'] = adv_list['EventId'] + " " + adv_list['EventTemplate'] + " " + adv_list['Occurrences']
adv_list1['result'] = adv_list1['Content']
adv_list2['result'] = adv_list2['Content']
# a corpus = a list of sentences
# a sentence = a list of words
corpus = []

print(adv_list1['result'])

invalid_string = 'XXXXXXXX_NEVER_XXXXXXXX'
invalid_sentence = [invalid_string]

abnormal = []
normal = []
for i in range(len(adv_list1['result'])):
    corpus.append(adv_list1['result'].loc[i].split(" "))
    abnormal.append(adv_list1['result'].loc[i].split(" "))
for i in range(len(adv_list2['result'])):
    corpus.append(adv_list2['result'].loc[i].split(" "))
    normal.append(adv_list2['result'].loc[i].split(" "))
#corpus = adv_list.to_numpy()
corpus.append(invalid_sentence)
print(corpus[0])

# FastText model is also provided by gensim package
# It is an advanced word2vec, see https://radimrehurek.com/gensim/models/fasttext.html

# Generate a dictionary for every word (a mapping between a word and its vector representation)
w2v_model_300 = gensim.models.Word2Vec(corpus, vector_size=300, min_count=1, workers=2, epochs=100)

## Save the dictionary if you want to re-use it
#w2v_model_300.save("patch_commit_voc50_mc5.w2v")

## If you have a saved dictionary, you can load it (so you don't need to repeatedly train/build-up it)
#  w2v_model_300 = gensim.models.Word2Vec.load("patch_commit_voc50_mc5.w2v")

print(w2v_model_300.wv.vectors.shape)

## Print vocabulary size, i.e. the # of words in the dictionary
vocab_size = len(w2v_model_300.wv.key_to_index)
print(vocab_size)


# save model
#w2v_model_300.save("patch_commit_voc50_mc5.w2v")
#%%
# if you have a 'word', and you want to get index, you can use
discard_idx = w2v_model_300.wv.key_to_index
print(discard_idx)
print("\n")
# if you want to get the vector representation for a give word
#print(w2v_model_300.wv[0])
#type(w2v_model_300.wv)

invalid_index = discard_idx.get(invalid_string)
print('invalid_idx', invalid_index)

import json
dictionary = {}
for i in range(len(w2v_model_300.wv)):
    dictionary[i] = w2v_model_300.wv[i].tolist()

_temp = dictionary[invalid_index]
dictionary[invalid_index] = dictionary[0]
dictionary[0] = _temp

a = json.dumps(dictionary,indent=4)

with open("AWS_vec.json", 'w') as f:
    f.write(a)

w2i = {}
str_for_zero = -1
for i in discard_idx:
    # NOTE: +1 due to logdeep's way
    w2i[i] = str(int(discard_idx[i]) + 1)
    print(i, discard_idx[i])
    if discard_idx[i] == 0:
        str_for_zero = i

w2i[str_for_zero] = str(invalid_index + 1)
w2i[invalid_string] = str(1)

b = json.dumps(w2i, indent=4)
with open("map.json", "w") as f:
    f.write(b)

corpus_val = []
normal_val = []
abnormal_val = []

for i in range(len(corpus)):
    item = []
    for j in range(len(corpus[i])):
        # NOTE: +1 due to logdeep's way
        v = corpus[i][j]
        #print('all', v, type(v), i, j, discard_idx.get(v))
        item.append(w2i[corpus[i][j]])
    corpus_val.append(item)
for i in range(len(normal)):
    item = []
    for j in range(len(normal[i])):
        # NOTE: +1 due to logdeep's way
        v = normal[i][j]
        #print('normal', v, type(v), i, j, discard_idx.get(v))
        item.append(w2i[normal[i][j]])
    normal_val.append(item)
for i in range(len(abnormal)):
    item = []
    for j in range(len(abnormal[i])):
        # NOTE: +1 due to logdeep's way
        v = abnormal[i][j]
        #print('ab', v, type(v), i, j, discard_idx.get(v))
        item.append(w2i[abnormal[i][j]])
    abnormal_val.append(item)


pd.DataFrame(corpus_val).to_csv('indexed_all.txt', sep=' ',header=False, index=False)
pd.DataFrame(normal_val).to_csv('indexed_normal.txt', sep=' ',header=False, index=False)
pd.DataFrame(abnormal_val).to_csv('indexed_abnormal.txt', sep=' ',header=False, index=False)


"""
json_string = "{\n\t"
try:
    for value in w2v_model_300.wv:
        for key in discard_idx:
            json_string += "\""+ str(discard_idx[key]) + "\" : [\n\t"
            for element in value:
                json_string += "\t" + str(element) + ",\n\t"
            if(65json.... != discard_idx[key]):
                json_string += "],\n\t"
            else:
                json_string += "]\n"
        json_string +="}"
        break
except:
    pass
"""

import json

maxlen = 100 # we allow at most 100 words for each sentence (a sentence is a sequence of words)

def generate_list(sentence, word2vecs, max_len):
    
    result_list = np.zeros((max_len), dtype = np.int32)
    
    i = 0
    
    for word in sentence:
        
        if word in word2vecs.key_to_index.keys():
            # print(word)
            # print(word2vecs.key_to_index[word])
            result_list[i] = word2vecs.key_to_index[word]
        #else:
            ## if the word cannot be found, use a default value
        i += 1
    return result_list


"""
a_list_representation_for_a_sentence = generate_list(adv_list[0], w2v_model_300.wv, maxlen)

# the representation for a sentence is a list, each word is represented by it index in dictionary
print(a_list_representation_for_a_sentence.shape)


print(a_list_representation_for_a_sentence)

"""


