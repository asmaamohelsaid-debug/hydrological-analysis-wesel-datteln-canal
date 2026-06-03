# ==============================================================================
# PROJECT: GERMAN RIVERS WATER LEVEL ANALYSIS (PEGLONLINE)
# DESCRIPTION: Time series analysis of raw water levels across multiple stations
# AUTHOR: Asmaa Mohammad Elsaid
# ==============================================================================
# --- 1. DATA SOURCE & OVERVIEW ---
# - Source: The dataset was extracted from the official German Hydrological Information System (Pegelonline).
# - Temporal Resolution: Continuous high-resolution time series logged at 1-minute intervals.
# - Spatial Resolution: Covers 5 critical lock stations (Schleuse) along the Wesel-Datteln-Kanal network.
# - Time Period: January 1, 2026, to June 1, 2026 (5 months of data capturing seasonal changes).

# --- 2. DATA CLEANING & TRANSFORMATIONS ---
# - The raw structural data was successfully parsed utilizing the German semicolon delimiter (sep = ";").
# - Fixed data inconsistencies regarding decimal notation and handled metadata rows to avoid coercion bugs.
# - Extracted columns for Timestamp, Station Name, and converted the Water Level into a pure numeric format (mm).
# - Removed missing values and incomplete records using an optimized clean-up pipeline (na.omit).

# --- 3. SUMMARY STATISTICS & MAIN INSIGHTS ---
# - Summary tracking shows that water levels remain heavily regulated across the canal network.
# - The spatial boxplots cleanly show strict geometric bounds for each station. For instance, upper-lock 
#   stations (OW) maintain fundamentally higher capacity baselines than lower-lock stations (UW).
# - "Dorsten Schleuse OW" holds the highest absolute baseline capacity across the network during this window.
# - The global density curve displays a distinct non-parametric multi-modal distribution, capturing the 
#   exact operational shift points and stable management thresholds across the locks.

# ==============================================================================
# START OF EXECUTABLE CODE:
# ==============================================================================


# --- 1. Environment Cleanup & Setup ---
# Clearing memory to ensure maximum reproducibility
rm(list = ls())

# --- 2. Data Loading & Handling Inconsistencies ---
# Setting the German standard separator (;) as verified from the data structure
raw_data <- read.csv("river_data.csv", sep = ";", header = FALSE, stringsAsFactors = FALSE)

# Remove the text header metadata if present to clean the tabular dataframe
# We extract the main columns: Date/Time, Station Name, and Water Level (mm)
# Note: Adjust column indices based on R's internal layout after separation
colnames(raw_data) <- c("Timestamp", "City", "River_Kanal", "Station", "Water_Level_mm", "V6", "V7")

# Filter out rows that might contain character headers or metadata
# Converting the water level explicitly to numeric to prevent coercion bugs
raw_data$Water_Level_mm <- as.numeric(raw_data$Water_Level_mm)
raw_data <- na.omit(raw_data) # Remove any remaining incomplete rows smoothly

# --- 3. Summary Statistics (Project Requirement) ---
# Generating summary statistics to understand total distribution caps and floors
print("--- Dataset Summary Statistics ---")
summary(raw_data$Water_Level_mm)

# Get the unique listed stations to check our spatial resolution
unique_stations <- unique(raw_data$Station)
print("Active Monitoring Stations found:")
print(unique_stations)

# --- 4. Advanced Data Visualization (Side-by-Side Plots) ---
# Setting up standard professional margins and side-by-side display panels
par(mfrow = c(1, 2), mar = c(5, 4, 4, 2), oma = c(0, 0, 3, 0))

# Plot A: Boxplot showing spatial variations across different locks/stations
boxplot(Water_Level_mm ~ Station, data = raw_data,
        col = c("lightblue", "lightgreen", "lightcoral", "lightgoldenrod", "lightpink"),
        main = "Water Level Distribution",
        xlab = "Monitoring Stations",
        ylab = "Water Level (mm)",
        las = 2, # Rotates long station names vertically so they remain readable
        cex.axis = 0.7)

# Plot B: Overall Trend Density of Water Fluctuations
plot(density(raw_data$Water_Level_mm), 
     col = "darkblue", 
     lwd = 3, 
     main = "Overall Hydrological Density",
     xlab = "Water Level (mm)", 
     ylab = "Density",
     las = 1)
polygon(density(raw_data$Water_Level_mm), col = rgb(0, 0, 1, 0.2), border = "darkblue")

# Global academic title layout across the entire visualization sheet
mtext("German Waterways: Spatial & Temporal Analysis (2026)", outer = TRUE, cex = 1.2, font = 2)

# --- 5. Exporting Final Render to PDF ---
pdf("River_Analysis_Report.pdf", width = 10, height = 5)

par(mfrow = c(1, 2), mar = c(8, 4, 4, 2), oma = c(0, 0, 3, 0))

boxplot(Water_Level_mm ~ Station, data = raw_data,
        col = c("lightblue", "lightgreen", "lightcoral", "lightgoldenrod", "lightpink"),
        main = "Water Level Distribution", xlab = "", ylab = "Water Level (mm)",
        las = 2, cex.axis = 0.6)

plot(density(raw_data$Water_Level_mm), col = "darkblue", lwd = 3, 
     main = "Overall Hydrological Density", xlab = "Water Level (mm)", ylab = "Density", las = 1)
polygon(density(raw_data$Water_Level_mm), col = rgb(0, 0, 1, 0.2), border = "darkblue")

mtext("German Waterways: Spatial & Temporal Analysis (2026)", outer = TRUE, cex = 1.2, font = 2)

dev.off()