--Query 3_
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id

    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    --Remote work not filtered here
GROUP BY skills_dim.skill_id
),

--Query 4_
average_salary AS (
    SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON
    job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON
    skills_job_dim.skill_id = skills_dim.skill_id

    WHERE job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
    --Remote work not filtered here

GROUP BY skills_job_dim.skill_id
)


SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
INNER JOIN average_salary
ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 20
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 10