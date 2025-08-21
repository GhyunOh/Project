# This repository is for benchmarking logdeep and logparser.

This repo is separated to three folders.  

**AWS_Dataset** - this folder is for our custom dataset folder. A S3 server access log is included with templates for logparsing. Unstructured folder is raw dataset, and structured folder is for parsed dataset.

**deeplog** - this is a repository from [here](https://github.com/donglee-afar/logdeep/tree/master). This folder is about deeplearning-based log analysis toolkit for automated anomaly detection. There are three models deeplog, loganomaly, and robustlog.

**logparser** - Logparser provides a toolkit and benchmarks for automated log parsing, which is a crucial step towards structured log analytics. By applying logparser, users can automatically learn event templates from unstructured logs and convert raw log messages into a sequence of structured events. Among many logparsing tools, Drain will be used for this benchmarking, because is the most effective log parsing method. Check this [repository](https://github.com/logpai/logparser) to see more logparsing tools.

---

## Reference

| Model | Paper reference |
| :--- | :--- |
|DeepLog| [**CCS'17**] [DeepLog: Anomaly Detection and Diagnosis from System Logs through Deep Learning](https://www.cs.utah.edu/~lifeifei/papers/deeplog.pdf)|
| Drain | [**ICWS'17**] [Drain: An Online Log Parsing Approach with Fixed Depth Tree](https://jiemingzhu.github.io/pub/pjhe_icws2017.pdf), by Pinjia He, Jieming Zhu, Zibin Zheng, and Michael R. Lyu. <br> [IBM-Drain3](https://github.com/IBM/Drain3): IBM's upgrade version of Drain in Python 3.6 with additional features. |

---

## Get started

**First**, You need to transform a unstructured log data to structured log data by using logparser.

Before transforming a log, you need to decide which part(s) of log will be constant part or actual log data. The constant part is tokens that describe a system operation template. For example:  
```Receiving block blk_750348333342684 src: /10.215.215.16:9999 dest: /10.215.215.16:9999``` # tokens are constant so logparser will transform to ```Receiving block <*> src: <*> dest: <*>```

**Second**, Once you decided, then you need to make or check a template(s) to parse your logs, if you are confusing about how to extract log key (i.e. log template), please check [here](/AWS_dataset/AWS_S3_templates.csv) or [here](logparser/logs/) and compare with your log data, if template events are matched with your log, you don't need to make a template, then go to next step, but if you cannot find matched one, you need to make a template.

**Third**, You need to modify a drain python file to compatible with your dataset. Check [here](/logparser/benchmark/Drain_benchmark.py).
Input_dir: The path of dataset folder that you want to parse a log.  
output_dir: The output directory of parsing results.  
benchmark_settings: Only json format is acceptable.   
explanation of parameters from benchmark_settings:
| Parameter | Explanation |
| :--- | :--- |
**log_file** | the path of where the specific log file is placed.  
**log_format** | separate the tokens with given format, in other words, create features.  
**regex** | using regular expression format to convert constant token(s) to <*>.
**st** | similarity threshold - if percentage of similar tokens for a log message is below this number, a new log cluster will be created.
**depth** | param depth: max depth levels of log clusters. Minimum is 2. For example, for depth==4, Root is considered depth level 1. Token count is considered depth level 2. First log token is considered depth level 3. Log clusters below first token node are considered depth level 4.  

If your log type is not listed inside python code, you need to create a new item. Even if your log type is listed, if you need some more regex to convert constant tokens, you may add them. 

Once you finished all above steps, run below command to parse logs.
```python 
cd logparser/benchmark
python Drain_benchmark.py
```

**Fourth**, You need to convert structured log to sequence or semantic data, you can check example [here](logdeep/data/hdfs/hdfs_test_normal). sequence or semantic data is converted based on [this](logdeep/data/hdfs/event2semantic_vec.json) file. You need to separate into two file, one is for normal case, and the other is for abnormal case.
**I am struggling with this section, I am looking for a method that creates a "event2semantic_vec.json" like file to convert structured log to sequence or semantic data.**
https://fasttext.cc/docs/en/english-vectors.html

**Fifth**, Train, predict, and evaluate the semantic data using with deeplog model(s).  

## Setup:
```
#python>= 3.6 version.
#run below commands in a terminal
pip install pytorch >= 1.1.0
cd logdeep/logdeep/dataset
vi log.py
```
config path as your log folder under "_ _name_ _" function.  
Also config path as your log folder in "telscope-log/logdeep/demo/deeplog.py"

## Training:
```python
cd deeplog/demo
python deeplog.py train
```
Once training is done, result will be saved under "telscope-log/deeplog/result/deeplog/" folder, pth extension files are trained model.

## Predict:
```python
cd deeplog/demo
python deeplog.py predict
```
Once prediction is done, it shows Precision, Recall, and F1 score, with these scores you can evaluate your log.
