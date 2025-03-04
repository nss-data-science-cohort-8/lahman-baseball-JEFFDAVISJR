
--1. Find all players in the database who played at Vanderbilt University. 
--Create a list showing each player's first and last names as well as the total salary they earned in the major leagues. 
--Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

SELECT DISTINCT ON (people.playerid) people.playerid, namegiven, schoolname
FROM people
LEFT JOIN collegeplaying ON people.playerid = collegeplaying.playerid
LEFT JOIN schools ON collegeplaying.schoolid = schools.schoolid
WHERE schoolname = 'Vanderbilt University'
ORDER BY people.playerid, yearid DESC 
LIMIT 25;

SELECT DISTINCT ON (people.playerid) people.playerid, namegiven, schoolname, salaries.salary
FROM people
LEFT JOIN collegeplaying ON people.playerid = collegeplaying.playerid
LEFT JOIN schools ON collegeplaying.schoolid = schools.schoolid
LEFT JOIN salaries ON people.playerid = salaries.playerid
WHERE schoolname = 'Vanderbilt University'
ORDER BY people.playerid, salaries.salary DESC
LIMIT 25;


SELECT namegiven, SUM(salary) AS total_salary, schools.schoolname
FROM people
LEFT JOIN salaries ON people.playerid = salaries.playerid
LEFT JOIN collegeplaying ON people.playerid = collegeplaying.playerid
LEFT JOIN schools ON collegeplaying.schoolid = schools.schoolid
WHERE schoolname = 'Vanderbilt University' 
	AND salary IS NOT NULL
GROUP BY namegiven, schools.schoolname
ORDER BY total_salary DESC
LIMIT 25;


2. Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
Determine the number of putouts made by each of these three groups in 2016.

SELECT 
    CASE
        WHEN pos = 'OF' THEN 'Outfield'
        WHEN pos = 'SS' THEN 'Infield'
        WHEN pos = '1B' THEN 'Infield'
        WHEN pos = '2B' THEN 'Infield'
        WHEN pos = '3B' THEN 'Infield'
        WHEN pos = 'P' THEN 'Battery'
        WHEN pos = 'C' THEN 'Battery'
    END AS pos_group,
    SUM(po) AS putouts
FROM fielding
WHERE yearid = 2016
GROUP BY pos_group
LIMIT 25;


3.Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. 
Do the same for home runs per game. Do you see any trends? 
(Hint: For this question, you might find it helpful to look at the generate_series function 
(https://www.postgresql.org/docs/9.1/functions-srf.html). 
If you want to see an example of this in action, check out this DataCamp video: 
https://campus.datacamp.com/courses/exploratory-data-analysis-in-sql/summarizing-and-aggregating-numeric-data?ex=6)

SELECT yearid, teamid,g
FROM pitching
LIMIT 25;

SELECT generate_series(1870, 1990, 10) AS decade, SUM(g) AS games_played
FROM pitching
GROUP BY decade
ORDER BY decade
LIMIT 25;

SELECT decade, SUM(g) AS games_played, sum(so) AS strike_outs, ROUND(SUM(so) * 1.0 /sum(g),2) AS avg_strike_outs
FROM (
    SELECT generate_series(1870, 2010, 10) AS decade
) AS series
LEFT JOIN pitching 
    ON pitching.yearid >= series.decade 
    AND pitching.yearid < series.decade + 10
GROUP BY decade
ORDER BY decade
LIMIT 25;

--4. Find the player who had the most success stealing bases in 2016, where success is measured as the percentage of stolen base attempts which are successful. 
--(A stolen base attempt results either in a stolen base or being caught stealing.) 
--Consider only players who attempted at least 20 stolen bases. 
--Report the players' names, number of stolen bases, number of attempts, and stolen base percentage.

SELECT namegiven, sum(sb) AS stolen_bases, SUM(cs) caught_stealing, sum(sb) + sum(cs) AS attempts, ROUND(sum(sb) *1.0/(sum(sb) + sum(cs)),2) AS stealing_pct
FROM people
LEFT JOIN batting ON people.playerid = batting.playerid
WHERE yearid = 2016
GROUP BY namegiven
HAVING SUM(sb) + SUM(cs) >= 20
ORDER BY stealing_pct DESC
LIMIT 25;

5. From 1970 to 2016, what is the largest number of wins for a team that did not win the world series? 
What is the smallest number of wins for a team that did win the world series? 
Doing this will probably result in an unusually small number of wins for a world series champion; determine why this is the case. 
Then redo your query, excluding the problem year. 
How often from 1970 to 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?

6. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? 
Give their full name and the teams that they were managing when they won the award.

7. Which pitcher was the least efficient in 2016 in terms of salary / strikeouts? Only consider pitchers who started at least 10 games (across all teams). 
Note that pitchers often play for more than one team in a season, so be sure that you are counting all stats for each player.

8. Find all players who have had at least 3000 career hits. 
Report those players' names, total number of hits, and the year they were inducted into the hall of fame 
(If they were not inducted into the hall of fame, put a null in that column.) 
Note that a player being inducted into the hall of fame is indicated by a 'Y' in the inducted column of the halloffame table.

9. Find all players who had at least 1,000 hits for two different teams. Report those players' full names.

10. Find all players who hit their career highest number of home runs in 2016. 
Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. 
Report the players' first and last names and the number of home runs they hit in 2016.

