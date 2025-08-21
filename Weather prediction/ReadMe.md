## Big Data Project  
**Weather Data Prediction Model (2010–2020)**

### Overview
This project aimed to build a machine learning-based weather prediction model using nationwide daily climate data provided by the Korean Meteorological Administration (KMA) between June 5 and August 5 for the years 2010–2020.  
The focus was on predicting whether the weather condition would be classified as "Clear" or "Rain," simplifying the complexity of real forecasts into a binary classification problem.

### Objectives
- Collect weather data (temperature, humidity, wind, etc.) through the KMA open API.  
- Preprocess and clean data into CSV format for modeling.  
- Apply machine learning models such as Lasso, Ridge, SVM, and Random Forest.  
- Evaluate accuracy using feature selection, scoring, cross-validation, and confusion matrices.  
- Achieve high-accuracy prediction for summer rainy season weather.  

### Data Description
- Source: Korean Meteorological Administration (KMA) API.  
- Time Period: June 5 – August 5, 2010–2020.  
- Features: 65 variables including temperature, humidity, wind speed, and wind direction.  
- Labels: Simplified into two categories – Clear / Rain.  

### Key Steps
1. Data Collection and Preprocessing  
   - Extracted daily data through KMA API.  
   - Converted raw data into CSV format and applied cleaning.  

2. Feature Selection and Modeling  
   - Automatic feature selection using Lasso and Ridge regression.  
   - Applied SVM and Random Forest with tuned parameters.  

3. Model Evaluation  
   - Scoring, feature importance analysis, and cross-validation.  
   - Confusion matrix applied for final performance evaluation.  

### Results
- Random Forest achieved over 90% accuracy for summer predictions.  
- Simplifying forecasts to Clear/Rain improved model stability.  
- Performance showed the potential of machine learning to assist weather forecasting.  

### Insights and Limitations
- Weather forecasts are inherently complex due to rapid natural changes.  
- KMA official forecasts include more categories (Cloudy, Fog, etc.), while the project simplified to binary labels.  
- Model accuracy limited by dataset size (summer only) and coarse daily-level data.  
- Expanding training to all seasons and hourly data would improve robustness.  
- Depending on the region, simply predicting all days as "Clear" already yields 70–80% accuracy.  
  Therefore, it is necessary to reduce the weight of "Clear" days and increase the representation of other weather conditions to improve prediction accuracy.  

### Conclusion
By applying machine learning models such as Random Forest, this project demonstrated that weather predictions can achieve over 90% accuracy during the summer rainy season.  
However, the study also highlighted challenges such as data imbalance—where “Clear” days dominate the dataset—and the need to rebalance data to improve accuracy for other weather conditions.  
This work emphasizes the potential of machine learning in weather forecasting while pointing to areas for further improvement.  
