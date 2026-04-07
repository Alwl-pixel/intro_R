# Session 2 workshop template (synthetic clinical-style data)
# Put CSVs in your project folder: data/

# 0) packages
library(tidyverse)
library(lubridate)

# 1) import
patients <- read_csv("data/patients.csv")
admissions <- read_csv("data/admissions.csv")
labs <- read_csv("data/labs.csv")
rx <- read_csv("data/prescriptions.csv")

# 2) quick look
glimpse(patients)
count(patients, sex)
summary(patients$age)

# 3) cleaning examples
patients_clean <- patients %>%
  mutate(
    sex = case_when(
      sex %in% c("M", "Male") ~ "Male",
      sex %in% c("F", "Female") ~ "Female",
      TRUE ~ NA_character_
    ),
    bmi_cat = case_when(
      bmi < 18.5 ~ "Underweight",
      bmi < 25 ~ "Healthy",
      bmi < 30 ~ "Overweight",
      bmi >= 30 ~ "Obese",
      TRUE ~ NA_character_
    )
  )

#admissions_clean <- admissions %>%
  mutate(
    admit_dt = ymd_hm(admit_datetime),
    discharge_dt = ymd_hm(discharge_datetime),
    # flag impossible dates
    discharge_before_admit = discharge_dt < admit_dt
  )

# 4) joins
adm_with_dx <- admissions_clean %>%
  left_join(select(patients_clean, patient_id, index_diagnosis), by = "patient_id")

# 5) simple summary
adm_with_dx %>%
  count(index_diagnosis, ward, sort = TRUE)

# 6) labs cleaning (convert messy strings)
labs_clean <- labs %>%
  mutate(
    value_num = parse_number(as.character(value)),
    collected_dt = ymd_hm(collected_datetime)
  )

# 7) basic plot
patients_clean %>%
  ggplot(aes(x = age)) +
  geom_histogram(binwidth = 5) +
  labs(title = "Age distribution (synthetic)")

# 8) mini example of the data science life cycle
patients_clean %>%
   group_by(index_diagnosis) %>%
  summarise(
   n = n(),
    crp_median = median(crp_admission_mg_l, na.rm = TRUE))%>% arrange(desc(crp_median))

#visualisation of mini example
patients_clean %>%
  ggplot(aes(x = index_diagnosis, y = crp_admission_mg_l)) +
  geom_boxplot() +
  coord_flip() +
  labs(x = NULL, y = "CRP (mg/L)")


