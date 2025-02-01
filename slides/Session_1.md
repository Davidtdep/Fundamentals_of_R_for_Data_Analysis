---
marp: true
theme: default
paginate: true
title: Introduction to R & Data Visualization
---

# 📊 Introduction to R & Data Visualization
### Fundamentals of R for Data Analysis  
**Instructor:** David A. Hernandez-Paez  
University of Cartagena  

---

# 🛠️ Getting Started with R  
- Install **R** and **RStudio**  
- RStudio interface overview  
- Basic operations in R  

---

# 🎨 What is ggplot2?  
- Part of the **tidyverse**  
- Based on **Grammar of Graphics**  
- Allows layered plotting  

```r
library(ggplot2)
ggplot(mtcars, aes(x=mpg, y=hp)) + geom_point()

