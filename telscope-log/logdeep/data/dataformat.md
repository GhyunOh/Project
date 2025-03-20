# Data Format Guideline

## Data Directory

make a data directory "DATA-NAME"

NAME is replaced with your data name.

For example, DATA-S3ATTACK

## Raw input data

- DATA-NAME/raw-normal.csv (csv.format)
- DATA-NAME/raw-abnormal.csv (csv.format)

## Processing code

- DATA-NAME/process.py

This script produces eight files. 

- unsupervised learning
    - unsup-train.txt (normal)
    - unsup-test-normal.txt (normal)
    - unsup-test-abnormal.txt (abnormal)
- supervised learning
    - sup-train.txt (normal + abnormal with labels)
    - sup-valid.txt (normal + abnormal with labels)
    - sup-test.txt (normal + abnormal with labels)

- event2semantic\_vec.json is a vector file of encoded numbers.

```
{
    "0": [
        0.0018273866609733406,
        0.0006673702293206326,
        0.018322005527010455,
        0.03347767749634861,
        -0.021414644260409482,
        ...              
        0.019736050780958973,
        0.018485348353973058,
        -0.008402216081839978,
        -0.018121015464595127
    ]
}
```

- map.json is a mapping between message to an index.

```
{
	0: "mesg1",
	1: "mesg2",
	...
	last-index: "last mesg"
}
```

This is an example how to run this code.


```
cd DATA-NAME

# input list
ls
process.py raw-normal.csv raw-abnormal.csv

# Processing data
python process.py raw-normal.csv raw-abnormal.csv


# output list
ls
python process.py raw-normal.csv raw-abnormal.csv
event2semantic_vec.json map.json
unsup-train.txt 
unsup-test-normal.txt 
unsup-test-abnormal.txt 
sup-train.txt 
sup-valid.txt 
sup-test.txt 

```
