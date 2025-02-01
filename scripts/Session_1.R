# Load the tidyverse package (which includes dplyr, ggplot2, etc.)
library(tidyverse)



# =============================================================================
# Step 1: Import the CSV File and Perform Analysis & Visualization
# =============================================================================

# Import the CSV file into R using the specified path
data <- read_csv("~/Desktop/Fundamentals_of_R_for_Data_Analysis/datasets/Session_1.csv")

# Display the first few rows of the imported data
head(data)

# -----------------------------------------------------------------------------
# Data Manipulation: Summarize Data by Treatment Group
# -----------------------------------------------------------------------------
summary_by_treatment <- data %>%
  group_by(Treatment) %>%
  summarise(
    avg_age = mean(Age),
    avg_pre_systolic = mean(Pre_Systolic),
    avg_post_systolic = mean(Post_Systolic),
    count = n()
  )
print(summary_by_treatment)

# -----------------------------------------------------------------------------
# 1. Bar Chart: Count of Patients by Treatment Group (split by Gender)
# -----------------------------------------------------------------------------
ggplot(data, aes(x = Treatment, fill = Gender)) +
  geom_bar(position = "dodge") +
  labs(
    title = "Bar Chart: Count of Patients by Treatment",
    x = "Treatment Group",
    y = "Patient Count"
  ) +
  theme_minimal()

# -----------------------------------------------------------------------------
# 2. Line Chart: Daily Average Post-Treatment Systolic BP by Treatment
# -----------------------------------------------------------------------------
# Create a summary grouped by MeasurementDate and Treatment
daily_summary <- data %>%
  group_by(MeasurementDate, Treatment) %>%
  summarise(avg_post_systolic = mean(Post_Systolic), .groups = "drop")

# Plot the daily averages for each treatment group
ggplot(daily_summary, aes(x = MeasurementDate, y = avg_post_systolic, color = Treatment)) +
  geom_line(size = 1) +
  geom_point(size = 2) +
  labs(
    title = "Line Chart: Daily Average Post-Treatment Systolic BP by Treatment",
    x = "Measurement Date",
    y = "Average Post-Treatment Systolic BP"
  ) +
  theme_minimal()

# -----------------------------------------------------------------------------
# 3. Violin Plot: Distribution of Post-Treatment Systolic BP by Treatment
# -----------------------------------------------------------------------------
ggplot(data, aes(x = Treatment, y = Post_Systolic, fill = Treatment)) +
  geom_violin(trim = FALSE) +
  labs(
    title = "Violin Plot: Distribution of Post-Treatment Systolic BP by Treatment",
    x = "Treatment Group",
    y = "Post-Treatment Systolic BP"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel1")

# -----------------------------------------------------------------------------
# 4. Box Plot: Cholesterol Distribution by Gender and Treatment
# -----------------------------------------------------------------------------
ggplot(data, aes(x = Gender, y = Cholesterol, fill = Treatment)) +
  geom_boxplot() +
  labs(
    title = "Box Plot: Cholesterol Distribution by Gender and Treatment",
    x = "Gender",
    y = "Cholesterol (mg/dL)"
  ) +
  theme_minimal() +
  scale_fill_brewer(palette = "Pastel2")

# -----------------------------------------------------------------------------
# 5. Scatter Plot: Relationship between Age and Post-Treatment Systolic BP, with Smooth Trend
# -----------------------------------------------------------------------------
ggplot(data, aes(x = Age, y = Post_Systolic, color = Treatment)) +
  geom_point(size = 3, alpha = 0.7) +
  geom_smooth() +
  labs(
    title = "Scatter Plot: Age vs. Post-Treatment Systolic BP",
    x = "Age (years)",
    y = "Post-Treatment Systolic BP"
  ) +
  theme_minimal() +
  scale_color_brewer(palette = "Set1")
