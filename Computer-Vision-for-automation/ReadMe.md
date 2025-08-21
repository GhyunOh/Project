# YOLO-Based Object Detection & Automation Script

This project demonstrates a full pipeline of **custom YOLO training, lightweight inference, and Windows automation**.  

---

## 📖 Overview
We developed a system where YOLO detects objects in specific regions of the screen and triggers automated actions through Windows APIs.  
The project combines **computer vision** and **automation** to achieve real-time decision-making with minimal resource usage.  

---

## ⚙️ Workflow

1. **Image Preprocessing (LabelImg → YOLO format)**  
   - Used **LabelImg** to annotate datasets in YOLO series format.  
   - Ensured compatibility for training with YOLOv5/YOLOv8.  

2. **Custom Training with Google Colab**  
   - Trained YOLO models using Colab with free GPU resources.  
   - Dataset uploaded and mounted directly in Colab.  
   - Hyperparameters tuned for custom objects.  

3. **Efficient Inference (Region Cropping)**  
   - Implemented **Python-based cropping** of specific window regions.  
   - Reduced **RAM usage** by only running detection within target areas.  

4. **Automation with Windows API**  
   - When YOLO detects an object in the cropped region, system triggers:  
     - **Keyboard inputs**  
     - **Mouse control**  
     - **Custom actions via Win32 API**  
   - Allows the computer to **interact automatically** based on detection results.  

---

## 🎯 Features
- End-to-end pipeline: Data labeling → Model training → Real-time detection → Automation  
- Lightweight design by cropping window regions  
- Works seamlessly with **Windows automation APIs**  
- Fully customizable automation scripts  

---

## 🛠️ Tech Stack
- **Python** (OpenCV, PyTorch, win32 API, keyboard/mouse control libraries)  
- **YOLO series models** (YOLOv5 / YOLOv8)  
- **LabelImg** for annotation  
- **Google Colab** (GPU-based training)  
- **Windows API (Win32)** for automation  

---

## 🚀 Impact
This project shows how **deep learning + system automation** can be integrated:  
- Reduces manual intervention through **automated workflows**  
- Optimized to run on limited resources  
- Can be adapted to multiple use cases (game automation, monitoring, assistive tools)  

---
