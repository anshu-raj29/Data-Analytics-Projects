# Operation Analytics and Investigating Metric Spike

## Project Overview

This project analyzes job review activity, user engagement, user growth, retention, device usage, and email engagement using SQL.

The project consists of two case studies:
- **Job Data Analysis**
- **Investigating Metric Spike**

## Business Problems

### Case Study 1 — Job Data Analysis

1. Analyze jobs reviewed over time.
2. Analyze throughput.
3. Analyze language share.
4. Identify duplicate rows.

### Case Study 2 — Investigating Metric Spike

5. Analyze weekly user engagement.
6. Analyze user growth.
7. Analyze weekly retention.
8. Analyze weekly engagement by device.
9. Analyze email engagement.

## Tech Stack

- MySQL
- MySQL Workbench
- SQL
- GitHub

## Database Tables

- `job_data`
- `users`
- `events`
- `email_events`

## Project Workflow

CSV Dataset → MySQL Database → Data Cleaning → SQL Queries → Analysis → Insights → Results

## Key Insights

### Q1 — Jobs Reviewed Over Time

Analyzed the number of jobs reviewed on each day.

### Q2 — Throughput Analysis

Calculated daily throughput based on jobs reviewed and total time spent.

### Q3 — Language Share Analysis

Calculated the percentage share of jobs across different languages.

### Q4 — Duplicate Rows Detection

Checked the job data for duplicate records. No exact duplicate rows were found.

### Q5 — Weekly User Engagement

Analyzed the number of unique active users participating in engagement events each week.

### Q6 — User Growth Analysis

Analyzed weekly new user registrations and cumulative user growth.

### Q7 — Weekly Retention Analysis

Analyzed user retention by comparing signup cohorts with their subsequent weekly engagement.

### Q8 — Weekly Engagement Per Device

Compared weekly active users across different devices.

### Q9 — Email Engagement Analysis

Analyzed emails sent, opened, and clicked, along with email open and click rates.

## Project Files

- `Operation_Analytics_and_Investigating_Metric_Spike.sql` — Complete SQL script.
- `Q1_Jobs_Reviewed.csv` — Q1 output.
- `Q2_Throughput.csv` — Q2 output.
- `Q3_Language_Share.csv` — Q3 output.
- `Q4_Duplicates.csv` — Q4 output.
- `Q5_Weekly_Engagement.csv` — Q5 output.
- `Q6_User_Growth.csv` — Q6 output.
- `Q7_Weekly_Retention.csv` — Q7 output.
- `Q8_Device_Engagement.csv` — Q8 output.
- `Q9_Email_Engagement.csv` — Q9 output.
