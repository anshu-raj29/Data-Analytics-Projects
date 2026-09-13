-- ============================================================
-- OPERATION ANALYTICS AND INVESTIGATING METRIC SPIKE
-- Trainity Data Analytics Internship Project
-- ============================================================


-- ============================================================
-- 1. DATABASE SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS operation_analytics;

USE operation_analytics;


-- ============================================================
-- 2. TABLE CREATION
-- ============================================================

DROP TABLE IF EXISTS job_data;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS email_events;


-- ------------------------------------------------------------
-- JOB DATA
-- ------------------------------------------------------------

CREATE TABLE job_data (
    ds DATE,
    job_id INT,
    actor_id INT,
    event VARCHAR(50),
    language VARCHAR(50),
    time_spent INT,
    org VARCHAR(50)
);


-- ------------------------------------------------------------
-- USERS
-- ------------------------------------------------------------

CREATE TABLE users (
    user_id INT,
    created_at DATETIME,
    company_id INT,
    language VARCHAR(50),
    activated_at DATETIME,
    state VARCHAR(50)
);


-- ------------------------------------------------------------
-- EVENTS
-- ------------------------------------------------------------

CREATE TABLE events (
    user_id INT,
    occurred_at DATETIME,
    event_type VARCHAR(50),
    event_name VARCHAR(100),
    location VARCHAR(100),
    device VARCHAR(100),
    user_type INT
);


-- ------------------------------------------------------------
-- EMAIL EVENTS
-- ------------------------------------------------------------

CREATE TABLE email_events (
    user_id INT,
    occurred_at DATETIME,
    action VARCHAR(100),
    user_type INT
);


-- ============================================================
-- 3. RAW TABLES FOR CSV IMPORT
--    Used because CSV dates need conversion before insertion
-- ============================================================

DROP TABLE IF EXISTS job_data_raw;
DROP TABLE IF EXISTS users_raw;
DROP TABLE IF EXISTS events_raw;
DROP TABLE IF EXISTS email_events_raw;


-- ------------------------------------------------------------
-- JOB DATA RAW
-- ------------------------------------------------------------

CREATE TABLE job_data_raw (
    ds VARCHAR(20),
    job_id INT,
    actor_id INT,
    event VARCHAR(50),
    language VARCHAR(50),
    time_spent INT,
    org VARCHAR(50)
);


-- ------------------------------------------------------------
-- USERS RAW
-- ------------------------------------------------------------

CREATE TABLE users_raw (
    user_id INT,
    created_at VARCHAR(30),
    company_id INT,
    language VARCHAR(50),
    activated_at VARCHAR(30),
    state VARCHAR(50)
);


-- ------------------------------------------------------------
-- EVENTS RAW
-- ------------------------------------------------------------

CREATE TABLE events_raw (
    user_id INT,
    occurred_at VARCHAR(30),
    event_type VARCHAR(50),
    event_name VARCHAR(100),
    location VARCHAR(100),
    device VARCHAR(100),
    user_type INT
);


-- ------------------------------------------------------------
-- EMAIL EVENTS RAW
-- ------------------------------------------------------------

CREATE TABLE email_events_raw (
    user_id INT,
    occurred_at VARCHAR(30),
    action VARCHAR(100),
    user_type INT
);


-- ============================================================
-- 4. CSV IMPORT
-- ============================================================

-- ------------------------------------------------------------
-- JOB DATA
-- ------------------------------------------------------------

LOAD DATA LOCAL INFILE 'E:/trainity/job_data.csv'
INTO TABLE job_data_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- ------------------------------------------------------------
-- USERS
-- ------------------------------------------------------------

LOAD DATA LOCAL INFILE 'E:/trainity/users.csv'
INTO TABLE users_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- ------------------------------------------------------------
-- EVENTS
-- ------------------------------------------------------------

LOAD DATA LOCAL INFILE 'E:/trainity/events.csv'
INTO TABLE events_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- ------------------------------------------------------------
-- EMAIL EVENTS
-- ------------------------------------------------------------

LOAD DATA LOCAL INFILE 'E:/trainity/email_events.csv'
INTO TABLE email_events_raw
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;


-- ============================================================
-- 5. CLEAN AND INSERT DATA
-- ============================================================

-- ------------------------------------------------------------
-- JOB DATA
-- CSV DATE FORMAT: MM/DD/YYYY
-- ------------------------------------------------------------

INSERT INTO job_data
    (ds, job_id, actor_id, event, language, time_spent, org)
SELECT
    STR_TO_DATE(ds, '%m/%d/%Y'),
    job_id,
    actor_id,
    event,
    language,
    time_spent,
    org
FROM job_data_raw;


-- ------------------------------------------------------------
-- USERS
-- CSV DATE FORMAT: DD-MM-YYYY HH:MM
-- ------------------------------------------------------------

INSERT INTO users
    (user_id, created_at, company_id, language, activated_at, state)
SELECT
    user_id,
    STR_TO_DATE(created_at, '%d-%m-%Y %H:%i'),
    company_id,
    language,
    STR_TO_DATE(activated_at, '%d-%m-%Y %H:%i'),
    state
FROM users_raw;


-- ------------------------------------------------------------
-- EVENTS
-- CSV DATE FORMAT: DD-MM-YYYY HH:MM
-- ------------------------------------------------------------

INSERT INTO events
    (user_id, occurred_at, event_type, event_name, location, device, user_type)
SELECT
    user_id,
    STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i'),
    event_type,
    event_name,
    location,
    device,
    user_type
FROM events_raw;


-- ------------------------------------------------------------
-- EMAIL EVENTS
-- CSV DATE FORMAT: DD-MM-YYYY HH:MM
-- ------------------------------------------------------------

INSERT INTO email_events
    (user_id, occurred_at, action, user_type)
SELECT
    user_id,
    STR_TO_DATE(occurred_at, '%d-%m-%Y %H:%i'),
    action,
    user_type
FROM email_events_raw;


-- ============================================================
-- 6. DATA VERIFICATION
-- ============================================================

SELECT COUNT(*) AS total_job_records
FROM job_data;

SELECT COUNT(*) AS total_users
FROM users;

SELECT COUNT(*) AS total_events
FROM events;

SELECT COUNT(*) AS total_email_events
FROM email_events;


-- ============================================================
-- CASE STUDY 1 — JOB DATA ANALYSIS
-- ============================================================


-- ============================================================
-- Q1. JOBS REVIEWED OVER TIME
-- ============================================================

SELECT
    ds,
    COUNT(*) AS jobs_reviewed
FROM job_data
GROUP BY ds
ORDER BY ds;


-- ============================================================
-- Q2. THROUGHPUT ANALYSIS
-- ============================================================

SELECT
    ds,
    COUNT(*) AS jobs_reviewed,
    SUM(time_spent) AS total_time_spent,
    ROUND(
        COUNT(*) / NULLIF(SUM(time_spent), 0),
        4
    ) AS throughput
FROM job_data
GROUP BY ds
ORDER BY ds;


-- ============================================================
-- Q3. LANGUAGE SHARE ANALYSIS
-- ============================================================

SELECT
    language,
    COUNT(*) AS total_jobs,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_share
FROM job_data
GROUP BY language
ORDER BY percentage_share DESC;


-- ============================================================
-- Q4. DUPLICATE ROWS DETECTION
-- ============================================================

SELECT
    ds,
    job_id,
    actor_id,
    event,
    language,
    time_spent,
    org,
    COUNT(*) AS duplicate_count
FROM job_data
GROUP BY
    ds,
    job_id,
    actor_id,
    event,
    language,
    time_spent,
    org
HAVING COUNT(*) > 1;


-- ============================================================
-- CASE STUDY 2 — INVESTIGATING METRIC SPIKE
-- ============================================================


-- ============================================================
-- Q5. WEEKLY USER ENGAGEMENT
-- ============================================================

SELECT
    YEARWEEK(occurred_at, 1) AS week,
    COUNT(DISTINCT user_id) AS active_users
FROM events
WHERE event_type = 'engagement'
GROUP BY YEARWEEK(occurred_at, 1)
ORDER BY week;


-- ============================================================
-- Q6. USER GROWTH ANALYSIS
-- ============================================================

SELECT
    YEARWEEK(created_at, 1) AS week,
    COUNT(*) AS new_users,
    SUM(COUNT(*)) OVER (
        ORDER BY YEARWEEK(created_at, 1)
    ) AS cumulative_users
FROM users
GROUP BY YEARWEEK(created_at, 1)
ORDER BY week;


-- ============================================================
-- Q7. WEEKLY RETENTION ANALYSIS
-- ============================================================

WITH user_cohorts AS (
    SELECT
        user_id,
        YEARWEEK(created_at, 1) AS cohort_week
    FROM users
),

weekly_activity AS (
    SELECT DISTINCT
        user_id,
        YEARWEEK(occurred_at, 1) AS activity_week
    FROM events
    WHERE event_type = 'engagement'
)

SELECT
    c.cohort_week,
    a.activity_week,
    COUNT(DISTINCT c.user_id) AS retained_users
FROM user_cohorts c
JOIN weekly_activity a
    ON c.user_id = a.user_id
GROUP BY
    c.cohort_week,
    a.activity_week
ORDER BY
    c.cohort_week,
    a.activity_week;


-- ============================================================
-- Q8. WEEKLY ENGAGEMENT PER DEVICE
-- ============================================================

SELECT
    YEARWEEK(occurred_at, 1) AS week,
    device,
    COUNT(DISTINCT user_id) AS active_users
FROM events
WHERE event_type = 'engagement'
GROUP BY
    YEARWEEK(occurred_at, 1),
    device
ORDER BY
    week,
    active_users DESC;


-- ============================================================
-- Q9. EMAIL ENGAGEMENT ANALYSIS
-- ============================================================

SELECT
    COUNT(
        CASE
            WHEN action LIKE 'sent_%'
            THEN 1
        END
    ) AS emails_sent,

    COUNT(
        CASE
            WHEN action = 'email_open'
            THEN 1
        END
    ) AS emails_opened,

    COUNT(
        CASE
            WHEN action = 'email_clickthrough'
            THEN 1
        END
    ) AS emails_clicked,

    ROUND(
        COUNT(
            CASE
                WHEN action = 'email_open'
                THEN 1
            END
        ) * 100.0 /
        NULLIF(
            COUNT(
                CASE
                    WHEN action LIKE 'sent_%'
                    THEN 1
                END
            ),
            0
        ),
        2
    ) AS open_rate,

    ROUND(
        COUNT(
            CASE
                WHEN action = 'email_clickthrough'
                THEN 1
            END
        ) * 100.0 /
        NULLIF(
            COUNT(
                CASE
                    WHEN action LIKE 'sent_%'
                    THEN 1
                END
            ),
            0
        ),
        2
    ) AS click_rate

FROM email_events;


-- ============================================================
-- END OF PROJECT
-- ============================================================