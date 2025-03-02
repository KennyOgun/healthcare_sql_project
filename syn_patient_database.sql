-- =====================================================================
-- SQL Queries for Modified Synthea Database (PostgreSQL)
-- Author: [Your Name]
-- =====================================================================

-- ==========================
-- 1. CREATE TABLES
-- ==========================

-- Conditions Table
CREATE TABLE conditions (
    start_date DATE,
    stop_date DATE,
    patient VARCHAR(1000),
    encounter VARCHAR(1000),
    code VARCHAR(1000),
    description VARCHAR(200)
);

-- Encounters Table
CREATE TABLE encounters (
    id VARCHAR(100),
    start TIMESTAMP,
    stop TIMESTAMP,
    patient VARCHAR(100),
    organization VARCHAR(100),
    provider VARCHAR(100),
    payer VARCHAR(100),
    encounter_class VARCHAR(100),
    code VARCHAR(100),
    description VARCHAR(100),
    base_encounter_cost FLOAT,
    total_claim_cost FLOAT,
    payer_coverage FLOAT,
    reason_code VARCHAR(100)
    -- reason_description VARCHAR(100) -- Uncomment if needed
);

-- Immunizations Table
CREATE TABLE immunizations (
    date TIMESTAMP,
    patient VARCHAR(100),
    encounter VARCHAR(100),
    code INT,
    description VARCHAR(500)
    -- base_cost FLOAT -- Uncomment if needed
);

-- Patients Table
CREATE TABLE patients (
    id VARCHAR(100),
    birthdate DATE,
    deathdate DATE,
    ssn VARCHAR(100),
    drivers VARCHAR(100),
    passport VARCHAR(100),
    prefix VARCHAR(100),
    first VARCHAR(100),
    last VARCHAR(100),
    suffix VARCHAR(100),
    maiden VARCHAR(100),
    marital VARCHAR(100),
    race VARCHAR(100),
    ethnicity VARCHAR(100),
    gender VARCHAR(100),
    birthplace VARCHAR(100),
    address VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    county VARCHAR(100),
    fips INT,
    zip INT,
    lat FLOAT,
    lon FLOAT,
    healthcare_expenses FLOAT,
    healthcare_coverage FLOAT,
    income INT,
    mrn INT
);

-- ==========================
-- 2. CHECK DATA LOADING
-- ==========================

-- Verify that data has been loaded correctly
SELECT * FROM public.patients;

-- ==========================
-- 3. SUBSETTING DATA
-- ==========================

-- Extract specific columns from the Patients table
SELECT 
    first, 
    last, 
    birthdate, 
    ssn, 
    passport, 
    id
FROM public.patients;

-- Retrieve distinct encounter types
SELECT DISTINCT encounter_class
FROM public.encounters;

-- ==========================
-- 4. FILTERING DATA
-- ==========================

-- Retrieve ICU Admissions in 2023
SELECT * 
FROM public.encounters
WHERE encounter_class = 'inpatient'
AND description = 'ICU Admission'
AND stop BETWEEN '2023-01-01 00:00' AND '2023-12-31 23:59';

-- Retrieve Outpatient & Ambulatory encounters
SELECT * 
FROM public.encounters
WHERE encounter_class IN ('outpatient', 'ambulatory');

-- ==========================
-- 5. COUNT & AGGREGATION
-- ==========================

-- Count of conditions by description
SELECT 
    description, 
    COUNT(*) AS condition_count
FROM public.conditions
GROUP BY description
ORDER BY condition_count DESC;

-- Count of conditions, excluding BMI 30.0-30.9, with more than 5000 cases
SELECT 
    description, 
    COUNT(*) AS condition_count
FROM public.conditions
WHERE description != 'Body Mass Index 30.0-30.9, adult'
GROUP BY description
HAVING COUNT(*) > 5000
ORDER BY condition_count DESC;

-- ==========================
-- 6. PRACTICE QUESTIONS
-- ==========================

-- 1. Retrieve all patients from Boston
SELECT * 
FROM public.patients
WHERE city = 'Boston';

-- 2. Retrieve patients diagnosed with Chronic Kidney Disease
SELECT * 
FROM public.conditions
WHERE code IN ('585.1', '585.2', '585.3', '585.4');

-- Alternative using condition descriptions
SELECT * 
FROM public.conditions
WHERE description IN (
    'Chronic kidney disease, Stage I', 
    'Chronic kidney disease, Stage II (mild)', 
    'Chronic kidney disease, Stage III (moderate)', 
    'Chronic kidney disease, Stage IV (severe)'
);

-- 3. Count patients per city, excluding Boston, where patient count > 100
SELECT 
    city, 
    COUNT(*) AS num_of_patients
FROM public.patients
WHERE city != 'Boston'
GROUP BY city
HAVING COUNT(*) > 100
ORDER BY num_of_patients DESC;

-- ==========================
-- 7. JOINS
-- ==========================

-- Join Immunizations with Patient Data
SELECT 
    t1.*, 
    t2.first, 
    t2.last, 
    t2.birthdate
FROM public.immunizations AS t1
LEFT JOIN public.patients AS t2
ON t1.patient = t2.id;
