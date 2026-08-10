CREATE DATABASE telecom_project;
USE telecom_project;


SELECT *
FROM telecom_data_sample
LIMIT 10;
SELECT COUNT(*) AS total_rows
FROM telecom_data_sample;

DESCRIBE telecom_data_sample;

-- Basic Dataset Summary

SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT `MSISDN/Number`) AS unique_customers
FROM telecom_data_sample;

-- Check Missing Customer IDs

SELECT
    COUNT(*) AS missing_customer_ids
FROM telecom_data_sample
WHERE `MSISDN/Number` IS NULL;

# Step 3: Basic Usage Statistics

SELECT
    ROUND(AVG(`Dur. (ms)`), 2) AS avg_duration_ms,
    MIN(`Dur. (ms)`) AS min_duration_ms,
    MAX(`Dur. (ms)`) AS max_duration_ms
FROM telecom_data_sample;

-- Step 4: Total Data Usage

SELECT
    ROUND(SUM(`Total DL (Bytes)`) / 1000000000, 2) AS total_download_gb,
    ROUND(SUM(`Total UL (Bytes)`) / 1000000000, 2) AS total_upload_gb
FROM telecom_data_sample;

-- Step 5: Top Handset Manufacturers

SELECT
    `Handset Manufacturer`,
    COUNT(*) AS customer_records
FROM telecom_data_sample
WHERE `Handset Manufacturer` IS NOT NULL
GROUP BY `Handset Manufacturer`
ORDER BY customer_records DESC
LIMIT 10;

-- Step 6: Top Handset Models

SELECT
    `Handset Type`,
    COUNT(*) AS customer_records
FROM telecom_data_sample
WHERE `Handset Type` IS NOT NULL
    AND `Handset Type` <> 'undefined'
GROUP BY `Handset Type`
ORDER BY customer_records DESC
LIMIT 10;

-- Step 7: Average Download and Upload Throughput

SELECT
    ROUND(AVG(`Avg Bearer TP DL (kbps)`), 2) AS avg_download_kbps,
    ROUND(AVG(`Avg Bearer TP UL (kbps)`), 2) AS avg_upload_kbps
FROM telecom_data_sample;

-- Step 8: Top 10 Customers by Total Data Usage

SELECT
    `MSISDN/Number` AS customer_id,
    ROUND(
        SUM(`Total DL (Bytes)` + `Total UL (Bytes)`) / 1000000000,
        2
    ) AS total_data_gb
FROM telecom_data_sample
WHERE `MSISDN/Number` IS NOT NULL
GROUP BY `MSISDN/Number`
ORDER BY total_data_gb DESC
LIMIT 10;

-- Step 9: Average Data Usage per Customer

SELECT
    ROUND(
        SUM(`Total DL (Bytes)` + `Total UL (Bytes)`)
        / COUNT(DISTINCT `MSISDN/Number`)
        / 1000000000,
        2
    ) AS avg_data_per_customer_gb
FROM telecom_data_sample
WHERE `MSISDN/Number` IS NOT NULL;

-- Step 10: Average Network Latency (RTT)

SELECT
    ROUND(AVG(`Avg RTT DL (ms)`), 2) AS avg_rtt_download_ms,
    ROUND(AVG(`Avg RTT UL (ms)`), 2) AS avg_rtt_upload_ms
FROM telecom_data_sample;

-- Step 11: Average TCP Retransmission

SELECT
    ROUND(AVG(`TCP DL Retrans. Vol (Bytes)`) / 1000000, 2)
        AS avg_tcp_dl_retrans_mb,

    ROUND(AVG(`TCP UL Retrans. Vol (Bytes)`) / 1000000, 2)
        AS avg_tcp_ul_retrans_mb

FROM telecom_data_sample;

-- Step 12: Top 10 Locations

SELECT
    `Last Location Name`,
    COUNT(*) AS customer_records
FROM telecom_data_sample
WHERE `Last Location Name` IS NOT NULL
GROUP BY `Last Location Name`
ORDER BY customer_records DESC
LIMIT 10;

-- Step 13: Application Data Usage

SELECT
    ROUND(SUM(`Youtube DL (Bytes)` + `Youtube UL (Bytes)`) / 1000000000, 2)
        AS youtube_gb,

    ROUND(SUM(`Netflix DL (Bytes)` + `Netflix UL (Bytes)`) / 1000000000, 2)
        AS netflix_gb,

    ROUND(SUM(`Social Media DL (Bytes)` + `Social Media UL (Bytes)`) / 1000000000, 2)
        AS social_media_gb

FROM telecom_data_sample;

-- Step 14: Gaming Data Usage

SELECT
    ROUND(
        SUM(`Gaming DL (Bytes)` + `Gaming UL (Bytes)`)
        / 1000000000,
        2
    ) AS gaming_gb
FROM telecom_data_sample;

-- Step 15: Google Data Usage

SELECT
    ROUND(
        SUM(`Google DL (Bytes)` + `Google UL (Bytes)`)
        / 1000000000,
        2
    ) AS google_gb
FROM telecom_data_sample;

-- Step 16: Email Data Usage

SELECT
    ROUND(
        SUM(`Email DL (Bytes)` + `Email UL (Bytes)`)
        / 1000000000,
        2
    ) AS email_gb
FROM telecom_data_sample;

-- Step 17: Compare Application Data Usage

SELECT 'Gaming' AS application,
       ROUND(SUM(`Gaming DL (Bytes)` + `Gaming UL (Bytes)`) / 1000000000, 2) AS usage_gb
FROM telecom_data_sample

UNION ALL

SELECT 'YouTube',
       ROUND(SUM(`Youtube DL (Bytes)` + `Youtube UL (Bytes)`) / 1000000000, 2)
FROM telecom_data_sample

UNION ALL

SELECT 'Netflix',
       ROUND(SUM(`Netflix DL (Bytes)` + `Netflix UL (Bytes)`) / 1000000000, 2)
FROM telecom_data_sample

UNION ALL

SELECT 'Google',
       ROUND(SUM(`Google DL (Bytes)` + `Google UL (Bytes)`) / 1000000000, 2)
FROM telecom_data_sample

UNION ALL

SELECT 'Email',
       ROUND(SUM(`Email DL (Bytes)` + `Email UL (Bytes)`) / 1000000000, 2)
FROM telecom_data_sample

UNION ALL

SELECT 'Social Media',
       ROUND(SUM(`Social Media DL (Bytes)` + `Social Media UL (Bytes)`) / 1000000000, 2)
FROM telecom_data_sample

ORDER BY usage_gb DESC;

-- Step 18: Customer Data Usage Category

SELECT
    `MSISDN/Number` AS customer_id,

    ROUND(
        (`Total DL (Bytes)` + `Total UL (Bytes)`)
        / 1000000000,
        2
    ) AS total_data_gb,

    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category

FROM telecom_data_sample
WHERE `MSISDN/Number` IS NOT NULL

LIMIT 20;

-- Step 19: Count Customers by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

  COUNT(DISTINCT `MSISDN/Number`) AS unique_customer_count

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY unique_customer_count DESC;

-- Step 20: Unique Customers by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

    COUNT(DISTINCT `MSISDN/Number`) AS unique_customer_count

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY unique_customer_count DESC;

-- Step 21: Average Data Usage by Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

    ROUND(
        AVG(`Total DL (Bytes)` + `Total UL (Bytes)`) / 1000000000,
        2
    ) AS avg_data_gb

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY avg_data_gb DESC;

-- Step 22: Average Download vs Upload by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

    ROUND(AVG(`Total DL (Bytes)`) / 1000000000, 2)
        AS avg_download_gb,

    ROUND(AVG(`Total UL (Bytes)`) / 1000000000, 2)
        AS avg_upload_gb

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY avg_download_gb DESC;

-- Step 23: Average Network Speed by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

    ROUND(AVG(`Avg Bearer TP DL (kbps)`), 2)
        AS avg_download_speed_kbps,

    ROUND(AVG(`Avg Bearer TP UL (kbps)`), 2)
        AS avg_upload_speed_kbps

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY avg_download_speed_kbps DESC;

-- Step 24: Average Network Latency by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

    ROUND(AVG(`Avg RTT DL (ms)`), 2)
        AS avg_rtt_download_ms,

    ROUND(AVG(`Avg RTT UL (ms)`), 2)
        AS avg_rtt_upload_ms

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY avg_rtt_download_ms ASC;

-- Step 25: Average TCP Retransmission by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'

        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'

        ELSE 'Low Usage'
    END AS usage_category,

    ROUND(
        AVG(`TCP DL Retrans. Vol (Bytes)`) / 1000000,
        2
    ) AS avg_tcp_dl_retrans_mb,

    ROUND(
        AVG(`TCP UL Retrans. Vol (Bytes)`) / 1000000,
        2
    ) AS avg_tcp_ul_retrans_mb

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL

GROUP BY usage_category

ORDER BY avg_tcp_dl_retrans_mb ASC;

-- Step 26: Handset Manufacturer by Usage Category

SELECT
    CASE
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
            THEN 'High Usage'
        WHEN (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 400000000
            THEN 'Medium Usage'
        ELSE 'Low Usage'
    END AS usage_category,

    `Handset Manufacturer`,

    COUNT(*) AS customer_records

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL
  AND `Handset Manufacturer` IS NOT NULL
  AND `Handset Manufacturer` <> 'undefined'

GROUP BY usage_category, `Handset Manufacturer`

ORDER BY usage_category, customer_records DESC;

-- Step 27: Top Handset Models for High Usage Customers

SELECT
    `Handset Type`,
    COUNT(*) AS customer_records

FROM telecom_data_sample

WHERE `MSISDN/Number` IS NOT NULL
  AND `Handset Type` IS NOT NULL
  AND `Handset Type` <> 'undefined'
  AND (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

GROUP BY `Handset Type`

ORDER BY customer_records DESC

LIMIT 10;

-- Step 28: Application Usage for High Usage Customers

SELECT 'Gaming' AS application,
       ROUND(
           SUM(`Gaming DL (Bytes)` + `Gaming UL (Bytes)`)
           / 1000000000,
           2
       ) AS usage_gb
FROM telecom_data_sample
WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

UNION ALL

SELECT 'YouTube',
       ROUND(
           SUM(`Youtube DL (Bytes)` + `Youtube UL (Bytes)`)
           / 1000000000,
           2
       )
FROM telecom_data_sample
WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

UNION ALL

SELECT 'Netflix',
       ROUND(
           SUM(`Netflix DL (Bytes)` + `Netflix UL (Bytes)`)
           / 1000000000,
           2
       )
FROM telecom_data_sample
WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

UNION ALL

SELECT 'Google',
       ROUND(
           SUM(`Google DL (Bytes)` + `Google UL (Bytes)`)
           / 1000000000,
           2
       )
FROM telecom_data_sample
WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

UNION ALL

SELECT 'Email',
       ROUND(
           SUM(`Email DL (Bytes)` + `Email UL (Bytes)`)
           / 1000000000,
           2
       )
FROM telecom_data_sample
WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

UNION ALL

SELECT 'Social Media',
       ROUND(
           SUM(`Social Media DL (Bytes)` + `Social Media UL (Bytes)`)
           / 1000000000,
           2
       )
FROM telecom_data_sample
WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000

ORDER BY usage_gb DESC;

-- Step 29: Top 10 High Usage Customers

SELECT
    `MSISDN/Number` AS customer_id,

    ROUND(
        SUM(`Total DL (Bytes)` + `Total UL (Bytes)`)
        / 1000000000,
        2
    ) AS total_data_gb

FROM telecom_data_sample

WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
  AND `MSISDN/Number` IS NOT NULL

GROUP BY `MSISDN/Number`

ORDER BY total_data_gb DESC

LIMIT 10;

-- Step 30: Top handset manufacturers among High Usage customers

SELECT
    `Handset Manufacturer`,
    COUNT(DISTINCT `MSISDN/Number`) AS customer_count
FROM telecom_data_sample

WHERE (`Total DL (Bytes)` + `Total UL (Bytes)`) >= 700000000
  AND `MSISDN/Number` IS NOT NULL
  AND `Handset Manufacturer` IS NOT NULL
  AND `Handset Manufacturer` <> 'undefined'

GROUP BY `Handset Manufacturer`

ORDER BY customer_count DESC

LIMIT 10;

USE telecom_project;

SELECT *
FROM telecom_satisfaction_scores
LIMIT 10;