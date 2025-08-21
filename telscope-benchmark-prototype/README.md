# Security Vulnerability Demonstration Projects

This repository contains multiple hands-on projects that reproduce and analyze well-known security vulnerabilities.  
Each project is designed for educational and research purposes, showing how the exploit works, how it can be reproduced in a controlled environment, and what lessons can be learned.

---

## 1. Python PIL/Pillow Remote Shell Command Execution (CVE-2018-16509)

- **Description:**  
  Ghostscript, when bundled with PIL/Pillow or ImageMagick, contains a vulnerability that allows arbitrary command execution due to a `-dSAFER` bypass before v9.24.  
  This vulnerability (discovered by Tavis Ormandy, Google Project Zero) can be triggered through malicious EPS images.  

- **Demo:**  
  - Run the environment with Docker Compose.  
  - Upload a crafted EPS file (`rce.jpg`) to execute commands such as creating a file on the server.  

- **Takeaway:**  
  Demonstrates how dependency libraries (like Ghostscript) can introduce severe risks to applications even when not directly used. :contentReference[oaicite:3]{index=3}

---

## 2. Apache Tomcat AJP Arbitrary File Read / Include Vulnerability (CVE-2020-1938, Ghostcat)

- **Description:**  
  Known as *Ghostcat*, this vulnerability in the AJP protocol of Apache Tomcat allows attackers to read or include arbitrary files from the webapp directory.  
  In cases where file upload functions are present, attackers may achieve remote code execution.  

- **Demo:**  
  - Local Tomcat 9.0.30 environment provided via Docker Compose.  
  - Exploit steps show how configuration files or source code can be accessed.  

- **Takeaway:**  
  Highlights the importance of securing AJP connectors and applying vendor patches to prevent information disclosure and file inclusion attacks. :contentReference[oaicite:4]{index=4}

---

## 3. Dataset / Repository Skeleton

- **Description:**  
  A placeholder for dataset-driven projects where datasets are excluded from the repository.  
  It provides structure and setup for integrating external datasets during experiments.  

- **Takeaway:**  
  Encourages secure handling of sensitive datasets by keeping them out of public repositories. :contentReference[oaicite:5]{index=5}

---

## ⚠️ Disclaimer
These projects are intended for **educational purposes only**.  
Do not use the provided code, scripts, or techniques on unauthorized systems. Always test within controlled environments.
