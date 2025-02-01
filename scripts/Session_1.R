# Load the tidyverse package (which includes dplyr, ggplot2, etc.)
library(tidyverse)

# =============================================================================
# Step 1: Create a Fictional Medical Study Dataset and Export as CSV
# =============================================================================

# Set seed for reproducibility
set.seed(123)

# Define the number of patients in our study
n <- 150

# Create a dataset simulating a study on hypertensive patients.
# Each patient has high pre-treatment blood pressure.
medical_data <- tibble(
  PatientID = 1:n,
  Age = sample(30:80, n, replace = TRUE),
  Gender = sample(c("Male", "Female"), n, replace = TRUE),
  Treatment = sample(c("Drug", "Placebo"), n, replace = TRUE),
  MeasurementDate = sample(seq(as.Date("2023-03-01"), as.Date("2023-03-10"), by = "day"), n, replace = TRUE),
  # High pre-treatment blood pressure values
  Pre_Systolic = rnorm(n, mean = 180, sd = 10),
  Pre_Diastolic = rnorm(n, mean = 110, sd = 5),
  Cholesterol = rnorm(n, mean = 200, sd = 30)
) %>%
  mutate(
    # For patients receiving the "Drug", simulate a significant reduction in systolic BP.
    # Post-treatment systolic pressure is drawn from a distribution with mean 120 and SD 5.
    # For the placebo group, post-treatment values remain equal to pre-treatment.
    Post_Systolic = if_else(Treatment == "Drug",
                            rnorm(n(), mean = 120, sd = 5),
                            Pre_Systolic),
    # Similarly, for diastolic pressure: Drug group sees a reduction (target mean 80),
    # while the placebo group remains unchanged.
    Post_Diastolic = if_else(Treatment == "Drug",
                             rnorm(n(), mean = 80, sd = 5),
                             Pre_Diastolic),
    # Calculate the reduction in systolic BP (Pre - Post)
    Systolic_Reduction = Pre_Systolic - Post_Systolic
  )

# Export the dataset to a CSV file named "medical_study_data.csv"
write_csv(medical_data, "medical_study_data.csv")

# (Optional) Print the first few rows to inspect the data structure
print(head(medical_data))

# =============================================================================
# Step 2: Import the CSV File and Perform Analysis & Visualization
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
