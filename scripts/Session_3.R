# ====================================================================
# 1. Load Required Libraries
# ====================================================================
# These libraries are necessary for data manipulation, regression modeling, 
# and visualization (heatmaps).
library(readxl)    # For reading Excel files
library(dplyr)     # For data manipulation
library(tidyr)     # For reshaping data
library(pheatmap)  # For generating heatmaps

# ====================================================================
# 2. Import Dataset
# ====================================================================
# Load the dataset from an Excel file. Modify the path as needed.
data <- read_excel("~/Desktop/Fundamentals_of_R_for_Data_Analysis/datasets/Session_3.xlsx")

# ====================================================================
# 3. Define Indicator Variables and Abbreviations
# ====================================================================
# Select the indicator columns (4:14) and assign them unique uppercase letter abbreviations.
indicators <- colnames(data)[4:14]
abbreviations <- LETTERS[1:length(indicators)]
indicator_map <- setNames(abbreviations, indicators)

# ====================================================================
# 4. Initialize Results DataFrame
# ====================================================================
# This dataframe will store the results of the regression models.
results <- data.frame(Indicator = character(),
                      Indicator_abr = character(),
                      Beta = numeric(),
                      P_value = numeric(),
                      Income_group = character(),
                      stringsAsFactors = FALSE)

# ====================================================================
# 5. Perform Simple Linear Regression for Each Income Group
# ====================================================================
# Loop through each income group (HIC, LIC, LMC, UMC).
for (group in unique(data$income_level_iso3c)) {
  
  # Filter the dataset for the current income group.
  data_group <- data %>% filter(income_level_iso3c == group)
  
  # Iterate over each indicator column (dependent variable).
  for (indicator in indicators) {
    
    # Remove rows with missing values in the independent or dependent variable.
    data_filtered <- data_group %>% select(publications, !!sym(indicator)) %>% na.omit()
    
    # Ensure there are enough data points to perform regression.
    if (nrow(data_filtered) > 1) {
      
      # Fit a simple linear regression model (Y ~ publications).
      model <- lm(reformulate("publications", response = indicator), data = data_filtered)
      
      # Extract regression coefficient (Beta) and p-value.
      beta <- coef(model)[2]
      p_value <- summary(model)$coefficients[2, 4]
      
      # Store results in the dataframe.
      results <- rbind(results, data.frame(Indicator = indicator,
                                           Indicator_abr = indicator_map[indicator],
                                           Beta = beta,
                                           P_value = p_value,
                                           Income_group = group,
                                           stringsAsFactors = FALSE))
    }
  }
}

# Print the final results dataframe.
print(results)

# ====================================================================
# 6. Define Function for Significance Levels
# ====================================================================
# This function assigns significance levels based on the p-value:
# - *** (p < 0.001)
# - **  (p < 0.01)
# - *   (p < 0.05)
# - Empty string if not significant
get_significance <- function(p_value) {
  if (is.na(p_value)) return("")  # Handle missing values
  if (p_value < 0.001) return("***")
  if (p_value < 0.01) return("**")
  if (p_value < 0.05) return("*")
  return("")
}

# ====================================================================
# 7. Prepare Data for Heatmap
# ====================================================================
# Reshape the results dataframe so that the rows are indicators (abbreviations)
# and the columns represent different income groups.

# Create a matrix of Beta coefficients
heatmap_data <- results %>%
  select(Indicator_abr, Income_group, Beta) %>%
  pivot_wider(names_from = Income_group, values_from = Beta) %>%
  column_to_rownames(var = "Indicator_abr")  # Set row names to indicator abbreviations

# Create a matrix of significance levels
significance_data <- results %>%
  select(Indicator_abr, Income_group, P_value) %>%
  pivot_wider(names_from = Income_group, values_from = P_value) %>%
  column_to_rownames(var = "Indicator_abr")

# Apply the function to map p-values to significance symbols (*, **, ***).
significance_data <- apply(significance_data, c(1,2), get_significance)

# Convert heatmap_data to a numeric matrix
heatmap_matrix <- as.matrix(heatmap_data)

# ====================================================================
# 8. Generate Heatmap with Clustering and Significance Markers
# ====================================================================
# The heatmap will:
# - Show Beta coefficients
# - Apply hierarchical clustering using Euclidean distance
# - Normalize rows for better visualization
# - Display significance markers inside the cells
pheatmap(heatmap_matrix, 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean",
         clustering_method = "complete",
         scale = "row",  # Normalize each row for better comparison
         main = "Publications",
         color = colorRampPalette(c("blue", "white", "red"))(50),
         display_numbers = significance_data)  # Add significance markers
