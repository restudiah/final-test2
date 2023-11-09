-- Create dimension tables
CREATE TABLE dim_user (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE dim_post (
    post_id INT PRIMARY KEY,
    post_text VARCHAR(500),
    post_date DATE,
    user_id INT REFERENCES dim_user(user_id)
);

CREATE TABLE dim_date (
    date_id DATE PRIMARY KEY
);


-- Populate dimension tables from raw tables
INSERT INTO dim_user (user_id, user_name, country)
SELECT user_id, user_name, country
FROM raw_users;

INSERT INTO dim_post (post_id, post_text, post_date, user_id)
SELECT post_id, post_text, post_date, user_id
FROM raw_posts;

INSERT INTO dim_date (date_id)
SELECT DISTINCT post_date FROM raw_posts;

-- Create fact table for post performance
CREATE TABLE fact_post_performance (
    date_id DATE REFERENCES dim_date(date_id),
    post_id INT REFERENCES dim_post(post_id),
    views INT,
    likes INT
);

-- fact_post_performance table
INSERT INTO fact_post_performance (date_id, post_id, views, likes)
SELECT rp.post_date, rl.post_id, COUNT(DISTINCT rp.user_id) AS views, COUNT(rl.user_id) AS likes
FROM raw_posts rp
LEFT JOIN raw_likes rl ON rp.post_id = rl.post_id
GROUP BY rp.post_date, rl.post_id;

-- Create fact table for daily posts per user
CREATE TABLE fact_daily_posts (
    date_id DATE REFERENCES dim_date(date_id),
    user_id INT REFERENCES dim_user(user_id),
    num_posts INT
);

-- Populate fact_daily_posts table
INSERT INTO fact_daily_posts (date_id, user_id, num_posts)
SELECT rp.post_date, rp.user_id, COUNT(rp.post_id) AS num_posts
FROM raw_posts rp
GROUP BY rp.post_date, rp.user_id;





