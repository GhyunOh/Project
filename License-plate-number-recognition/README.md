# Non-Commercial Licensed Models

## 1. YOLOv5 and YOLOv8
- YOLO models require YAML files for training configurations, making them quick and easy to train and fine-tune.
- Trained models are also straightforward to implement in code.

### Resources
- [Training Guide](https://deeplearning-hub.github.io/TestCase/)
- [YOLOv5 Plate Detection Repo](https://github.com/bharatsubedi/ALPR-Yolov5)

### YOLOv5 Workflow
Using two YOLOv5 models:
1. The first model detects plates.
2. The second model detects characters on the plate.

*Status: Not tested.*

- [YOLOv8 Plate Detection Repo](https://github.com/Muhammad-Zeerak-Khan/Automatic-License-Plate-Recognition-using-YOLOv8)

### YOLOv8 Workflow
Using two YOLOv8 models:
1. The first model detects the car.
2. The second model detects the plate, crops it, and converts it to grayscale to improve OCR accuracy and reduce processing time.
3. Integrated with DeepSort to generate a unique ID for detected cars, avoiding redundant OCR processes (OCR model is resource-intensive).

*Status: Not tested.*

---

# Commercial Licensed Models

## 1. Detectron2
- Detectron2 uses a COCO-style dataset with JSON annotations for training.
- Slow for both training and detection.

### Training Code
```python
from detectron2.engine import DefaultTrainer  
from detectron2.config import get_cfg  
from detectron2 import model_zoo  
from detectron2.evaluation import COCOEvaluator, inference_on_dataset  
from detectron2.data import build_detection_test_loader  

cfg = get_cfg()  
cfg.merge_from_file(model_zoo.get_config_file("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml"))   
cfg.DATASETS.TRAIN = ("my_train",)  
cfg.DATASETS.TEST = ("my_val",)  
cfg.DATALOADER.NUM_WORKERS = 2  
cfg.MODEL.WEIGHTS = model_zoo.get_checkpoint_url("COCO-InstanceSegmentation/mask_rcnn_R_50_FPN_3x.yaml")   
cfg.SOLVER.IMS_PER_BATCH = 2  
cfg.SOLVER.BASE_LR = 0.00025  
cfg.SOLVER.MAX_ITER = 3000  
cfg.MODEL.ROI_HEADS.BATCH_SIZE_PER_IMAGE = 128  
cfg.MODEL.ROI_HEADS.NUM_CLASSES = 2  
cfg.OUTPUT_DIR = "./output"  

trainer = DefaultTrainer(cfg)  
trainer.resume_or_load(resume=False)  
trainer.train()

# evaluating model  
evaluator = COCOEvaluator("my_val", cfg, False, output_dir="./output/")  
val_loader = build_detection_test_loader(cfg, "my_val")  
inference_on_dataset(trainer.model, val_loader, evaluator)  
```
- Trained on 7000 images, batch size of 16, for 10 epochs, with a learning rate of 0.001, taking approximately 4 days to train.
- Initial training resulted in inaccurate detections with overlapping bounding boxes, leading to parameter adjustments: batch size of 8, 50 epochs, and learning rate of 0.01. The issue persisted, so switched to the EfficientDet model.

### Other People’s Work
- [Detectron2 Plate Detection](https://github.com/nevalsar/detectron2-license-plate-detection)
  - Attempted to test this model, but encountered multiple errors. Tried using Conda for a virtual environment but still faced issues. The author recommended using [pyenv](https://github.com/pyenv/pyenv-virtualenv); however, this was skipped.

## 2. EfficientDet
- [EfficientDet Github Repo](https://github.com/xuannianz/EfficientDet)
- EfficientDet uses TensorFlow rather than PyTorch, so separate environments may be needed to avoid dependency conflicts.
- Trained with COCO and Pascal VOC XML styles.

### Other People’s Work
- [License Plate Detection and Recognition](https://github.com/arrafi-musabbir/license-plate-detection-recognition)
  - This repo provides pretrained models trained with YOLOv5, YOLOv7, YOLOv8, Faster R-CNN, SSD, and EfficientDet for license plate and character recognition. Licensed under GPL 3.0, so not allowed for commercial projects. All projects were conducted using Tesseract-OCR.

## 3. YOLOX
- [YOLOX Github Repo](https://github.com/Megvii-BaseDetection/YOLOX)
- YOLOX supports COCO and Pascal VOC XML styles for training, with high performance in training speed and detection accuracy.
- YOLOX is free for commercial use (not developed by Ultralytics).

### Training YOLOX
- Dataset format required for training:
    ```
    └── datasets/
        └── mydataset/
            ├── train2017/
            ├── val2017/
            └── annotations/
                ├── instances_train2017.json
                └── instances_val2017.json
    ```
- Custom config file:

from yolox.exp import Exp as MyExp  

class Exp(MyExp):  
    def __init__(self):  
        super(Exp, self).__init__()  
        self.num_classes = 2  
        self.depth = 0.33  
        self.width = 0.50  
        self.data_dir = "datasets/mydataset"  
        self.train_ann = "instances_train2017.json"  
        self.val_ann = "instances_val2017.json"  
        self.max_epoch = 50  
        self.eval_interval = 10  
        self.print_interval = 10  

- Training command (run from the `YOLOX` directory):

python tools/train.py -f exps/my_yolox.py -d 1 -b 8 --fp16 -o  

- *Note:* YOLOX returns object center coordinates (cx, cy), not bounding box corners (x1, y1, x2, y2), when detecting objects.

---

# OCR Models

- EasyOCR and Tesseract-OCR were tested. These two models conflict with each other, so it is recommended to use them in separate virtual environments to avoid OpenCV package issues.
- OCR accuracy is lower on full-color images; converting images to grayscale or enhancing edges with black on a white background can improve detection accuracy.
- For best results, crop the area of interest as OCR processes are resource-intensive.

---

# Datasets

- [Dataset 1](https://universe.roboflow.com/roboflow-universe-projects/license-plate-recognition-rxg4e/dataset/5)
- [Dataset 2](https://github.com/nevalsar/detectron2-license-plate-detection/tree/main/license-plate-dataset)

---

# Image Preprocessing

- [Guide 1](https://docs.roboflow.com/datasets/image-preprocessing)
- [Guide 2](https://blog.roboflow.com/coco-dataset/)
