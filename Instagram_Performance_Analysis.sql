SELECT * FROM public."Insta_Performance"

# Q1 Identify which format (Reel, Photo, Video, Carousel) is most efficient at converting
#    reach into followers.

SELECT 
    media_type,
    COUNT(post_id) AS total_posts,
    ROUND(AVG(engagement_rate)::numeric,2) AS avg_engagement_rate,
    ROUND(AVG(followers_gained), 0) AS avg_followers_gained,
    ROUND(SUM(followers_gained) * 1.0 / NULLIF(SUM(reach), 0), 4) AS follower_conversion_ratio
FROM public."Insta_Performance"
GROUP BY media_type
ORDER BY avg_engagement_rate DESC;

# Q2 dentify high-performing niches and "High-Risk" segments where reach is high but engagement 
#    is failing to retain interest.

SELECT 
    content_category,
    COUNT(post_id) AS post_count,
    ROUND(AVG(reach), 0) AS avg_reach,
    ROUND(AVG(engagement_rate)::numeric,2) AS avg_engagement,
    CASE 
        WHEN AVG(engagement_rate) < 10 THEN 'High Retention Risk'
        WHEN AVG(engagement_rate) BETWEEN 10 AND 20 THEN 'Moderate'
        ELSE 'Sticky Content'
    END AS retention_status
FROM public."Insta_Performance"
GROUP BY content_category
ORDER BY avg_reach DESC;

# Q3 Test if "Shares" or "Saves" are more strongly linked to new follower acquisition.

SELECT 
    CASE 
        WHEN shares > (SELECT AVG(shares) FROM public."Insta_Performance") THEN 'High Shares'
        ELSE 'Low Shares'
    END AS share_category,
    CASE 
        WHEN saves > (SELECT AVG(saves) FROM public."Insta_Performance") THEN 'High Saves'
        ELSE 'Low Saves'
    END AS save_category,
    ROUND(AVG(followers_gained), 0) AS avg_followers_gained
FROM public."Insta_Performance"
GROUP BY share_category, save_category
ORDER BY avg_followers_gained DESC;

#Q4 Identify the "sweet spot" for hashtag counts to maximize reach without appearing spammy.

SELECT 
    CASE 
        WHEN hashtags_count = 0 THEN 'No Hashtags'
        WHEN hashtags_count BETWEEN 1 AND 5 THEN 'Low (1-5)'
        WHEN hashtags_count BETWEEN 6 AND 15 THEN 'Medium (6-15)'
        ELSE 'High (16-30)'
    END AS hashtag_density,
    ROUND(AVG(engagement_rate)::numeric,2) AS avg_engagement_rate,
    ROUND(AVG(reach), 0) AS avg_reach
FROM public."Insta_Performance"
GROUP BY hashtag_density
ORDER BY avg_engagement_rate DESC;

#Q5 Determine which discovery channel (Explore, Home Feed, etc.) provides the most "sticky" 
#   or engaged audience.

SELECT 
    traffic_source,
    ROUND(AVG(impressions), 0) AS avg_impressions,
    ROUND(AVG(engagement_rate)::numeric,2) AS avg_engagement,
    ROUND(AVG(followers_gained), 0) AS avg_followers_gained
FROM public."Insta_Performance"
GROUP BY traffic_source
ORDER BY avg_followers_gained DESC;


# Q6 Provide actionable creative guidelines for content creators on the optimal caption length.

SELECT 
    CASE 
        WHEN caption_length < 50 THEN 'Short (<50 chars)'
        WHEN caption_length BETWEEN 50 AND 150 THEN 'Medium (50-150)'
        ELSE 'Long (>150 chars)'
    END AS caption_type,
    ROUND(AVG(engagement_rate)::numeric,2) AS avg_engagement,
    ROUND(AVG(reach), 0) AS avg_reach
FROM public."Insta_Performance"
GROUP BY caption_type
ORDER BY avg_engagement DESC;