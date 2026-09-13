# Instagram User Analytics

## Project Overview

The project analyzes Instagram user activity to generate insights on user engagement, content activity, hashtags, registrations, and potential bot accounts.

## Business Problems

### Marketing Analysis

1. Identify the five oldest users.
2. Identify users who have never posted a photo.
3. Identify the contest winner based on the photo with the highest number of likes.
4. Identify the five most commonly used hashtags.
5. Determine the day of the week with the highest number of user registrations.

### Investor Metrics

6. Calculate the average number of posts per user.
7. Identify users who liked every single photo.

## Tech Stack

- MySQL
- MySQL Workbench
- SQL
- GitHub

## Database Tables

- Users
- Photos
- Comments
- Likes
- Follows
- Tags
- Photo_Tags

## Project Workflow

Dataset → MySQL Database → SQL Queries → Analysis → Insights → Results

## Key Insights

### Q1 — Loyal User Reward

Identified the five oldest users based on registration date.

### Q2 — Inactive User Engagement

Identified users who have never posted a photo.

### Q3 — Contest Winner

Identified the photo with the highest number of likes and its owner.

### Q4 — Hashtag Research

Identified the five most commonly used hashtags.

### Q5 — Ad Campaign Launch

Identified the day of the week with the highest number of user registrations.

### Q6 — User Engagement

Calculated the average number of posts per user.

### Q7 — Bots & Fake Accounts

Checked for users who liked every single photo. No user liked all 514 photos in the dataset.

## Project Files

- `Instagram_User_Analytics.sql` — Complete SQL script.
- `Q1_Oldest_Users.csv` — Q1 output.
- `Q2_Inactive_Users.csv` — Q2 output.
- `Q3_Contest_Winner.csv` — Q3 output.
- `Q4_Top_Hashtags.csv` — Q4 output.
- `Q5_Registration_Day.csv` — Q5 output.
- `Q6_User_Engagement.csv` — Q6 output.
- `Q7_Bot_Users.csv` — Q7 output.
