# Load the readr package (used for reading CSV files)
library(readr)

# Read in the patients dataset from the data/ folder
# "data/patients.csv" is a relative path (from the project folder)
patients <- read_csv("data/patients.csv")

# Read in the admissions dataset
admissions <- read_csv("data/admissions.csv")


# Print the patients dataset to the console
# This shows the data in a simple table format
print(patients)

# Look at the structure of the dataset
# Shows:
# - column names
# - data types (e.g. numeric, character)
# - first few values
str(patients)

# Get a summary of each column
# For numeric variables: min, max, median, mean
# For categorical variables: counts
summary(patients)


# Create a histogram of the age variable
# This shows the distribution (how ages are spread out)
hist(patients$age)
