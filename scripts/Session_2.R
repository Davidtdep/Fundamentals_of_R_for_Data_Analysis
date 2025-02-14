# Load necessary libraries
library(tidyverse)  # Includes dplyr (data manipulation) and ggplot2 (visualization)
library(ggsignif)   # Adds significance annotations to plots

# =============================================================================
# Step 1: Import the CSV File
# =============================================================================

# Load the dataset (update the path if needed)
data <- read_csv("~/Desktop/Fundamentals_of_R_for_Data_Analysis/datasets/Session_1.csv")

# =============================================================================
# Step 2: Categorize Systolic Blood Pressure
# =============================================================================

# Create categorical variables for pre- and post-treatment systolic BP
data <- data %>%
  mutate(Pre_Systolic_Status = ifelse(Pre_Systolic > 125, "High", "Normal"),
         Post_Systolic_Status = ifelse(Post_Systolic > 125, "High", "Normal"))

# =============================================================================
# Step 3: Create and Print a Contingency Table
# =============================================================================

# Generate a frequency table for Post-treatment BP status by treatment group
table_contingency <- table(data$Post_Systolic_Status, data$Treatment)

# Display the contingency table
print(table_contingency)

# =============================================================================
# Step 4: Perform Fisher's Exact Test
# =============================================================================

# Fisher's test checks if there is a significant association between treatment
# and post-treatment BP status
fisher_result <- fisher.test(table_contingency)

# Print Fisher's test results (p-value, odds ratio, confidence interval)
print(fisher_result)

# =============================================================================
# Step 5: Check Normality of Post-Treatment Systolic BP
# =============================================================================

# Shapiro-Wilk test checks if Post_Systolic follows a normal distribution
shapiro.test(data$Post_Systolic[data$Treatment == "Drug"])    # Drug group
shapiro.test(data$Post_Systolic[data$Treatment == "Placebo"]) # Placebo group

# =============================================================================
# Step 6: Compare Post-Treatment Systolic BP between Treatment Groups
# =============================================================================

# Perform an independent t-test to compare mean Post_Systolic values
t_test_result <- t.test(Post_Systolic ~ Treatment, data = data, var.equal = FALSE)

# Print t-test results (p-value, confidence interval, mean difference)
print(t_test_result)

# =============================================================================
# Step 7: Visualize the Data with a Boxplot + Significance Test
# =============================================================================

ggplot(data, aes(x = Treatment, y = Post_Systolic, fill = Treatment)) +
  geom_boxplot() +  # Create a boxplot to show distribution +
  geom_jitter() +
  labs(title = "Post-Treatment Systolic Blood Pressure",
       x = "Treatment Group",
       y = "Post-Treatment Systolic BP") +
  theme_minimal() +  # Use a clean theme
  geom_signif(comparisons = list(c("Drug", "Placebo")), 
              map_signif_level = TRUE,  # Auto-generate p-value significance asterisks
              test = "t.test")  # Perform a t-test for significance annotation


