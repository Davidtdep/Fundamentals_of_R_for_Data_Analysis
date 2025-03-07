# ================================
# 1. Load the dataset
# ================================
data <- read.csv("~/Desktop/Fundamentals_of_R_for_Data_Analysis/datasets/Session_2.csv")

# ================================
# 2. Install and load required packages
# ================================
if (!require("dunn.test")) install.packages("dunn.test", dependencies = TRUE)
if (!require("ggplot2")) install.packages("ggplot2", dependencies = TRUE)
if (!require("ggsignif")) install.packages("ggsignif", dependencies = TRUE)

library(dunn.test)
library(ggplot2)
library(ggsignif)

# ================================
# 3. Perform the Kruskal-Wallis test
# ================================
kruskal_result <- kruskal.test(Pain_Level ~ Treatment, data = data)

# Display the test result
print(kruskal_result)

# ================================
# 4. Conduct Dunn’s post-hoc test if Kruskal-Wallis is significant
# ================================
if (kruskal_result$p.value < 0.05) {
  posthoc_result <- dunn.test(data$Pain_Level, data$Treatment, method = "bonferroni")
  print(posthoc_result)
} else {
  cat("No significant differences found between treatments.\n")
}

# Convert post-hoc test results into a dataframe
posthoc_result <- as.data.frame(posthoc_result)

# ================================
# 5. Define significance levels for p-values
# ================================
posthoc_result$Significance <- cut(
  posthoc_result$P.adjusted,
  breaks = c(-Inf, 0.001, 0.01, 0.05, Inf),
  labels = c("***", "**", "*", "ns") # "ns" = not significant
)

# ================================
# 6. Prepare pairwise comparisons for ggplot2
# ================================
comparisons_list <- strsplit(posthoc_result$comparisons, " - ")
comparisons_list <- lapply(comparisons_list, function(x) as.character(x))

# ================================
# 7. Create a bar plot with post-hoc significance annotations
# ================================
ggplot(data, aes(x = Treatment, y = Pain_Level)) +
  geom_bar(stat = "summary", fun = "mean", fill = "steelblue", alpha = 0.7) +  # Mean bars
  geom_errorbar(stat = "summary", fun.data = mean_se, width = 0.2) +  # Error bars
  geom_jitter(width = 0.2, alpha = 0.3) +  # Scatter points for data distribution
  geom_signif(
    comparisons = comparisons_list,
    annotations = posthoc_result$Significance, 
    tip_length = 0.02
  ) +
  labs(title = "Comparison of Pain Levels Across Treatments",
       x = "Treatment",
       y = "Pain Level (Mean ± SE)") +
  theme_minimal()
